//
//  DeksTableViewController.swift
//  flipflop
//
//  Created by Julian Tescher on 7/5/16.
//  Copyright © 2016 Michelle Venetucci Harvey. All rights reserved.
//

import UIKit
import GoogleAPIClient
import GTMOAuth2

class DeksTableViewController: UITableViewController {

    // MARK: - Properties
    var deks = [Dek]()
    var currentDek: Dek?

    // Google Drive Config
    private let gSheeetsBaseUrl = "https://sheets.googleapis.com/v4/spreadsheets"
    private let gDriveKeychainItemName = "Drive API"
    private let gDriveClientId = "645991755009-u35dnr5dkfotde9achst7s1lsii57sot.apps.googleusercontent.com"
    private let gdriveService = GTLServiceDrive()
    private let scopes = [kGTLAuthScopeDriveMetadata, "https://www.googleapis.com/auth/spreadsheets"]


    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the Drive API service & load existing credentials from the keychain if available.
        if let authorizer = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(gDriveKeychainItemName, clientID: gDriveClientId, clientSecret: nil) {
            gdriveService.authorizer = authorizer
        }
    }

    // When the view appears, ensure that the Drive API service is authorized, and perform API calls.
    override func viewDidAppear(animated: Bool) {
        if gdriveService.authorizer?.canAuthorize ?? false {
            fetchSpreadsheets()
        } else {
            // Not yet authorized, request authorization by pushing the login UI onto the UI stack.
            presentViewController(createAuthController(), animated: true, completion: nil)
        }
    }


    // MARK: - GoogleAPIClient/Drive

    // Construct query to get sheet for dek
    private func fetchDek(dek: Dek) {
        currentDek = dek
        let range = "A1:B"
        let url = String(format:"%@/%@/values/%@", gSheeetsBaseUrl, dek.gDriveID, range)
        let params = ["majorDimension": "ROWS"]
        let fullUrl = GTLUtilities.URLWithString(url, queryParameters: params)
        gdriveService.fetchObjectWithURL(fullUrl, objectClass: GTLObject.self, delegate: self, didFinishSelector: #selector(displayObjectWithTicket(_:finishedWithObject:error:)))
    }

    // Process the response and display the dek.
    func displayObjectWithTicket(ticket: GTLServiceTicket, finishedWithObject object: GTLObject, error: NSError?) {
        guard let currentDek = currentDek else { return }

        if let error = error {
            showAlert("Error", message: error.localizedDescription)
        } else {
            if let textPairs = object.JSON["values"] as? [[String]] {
                let questionsWithAnswers = textPairs.map { (textPair: [String]) in
                    return Question(text: textPair.first!, answer: Answer(text: textPair.last!))
                }
                let dek = Dek(gDriveID: currentDek.gDriveID, name: currentDek.name, questions: questionsWithAnswers)

                // TODO seque with current deck once that view is ready, for now just print
                print("name: \(dek.name), questions: \(dek.questions)")
            }
        }

    }

    // Construct a query to get names and IDs of sheets.
    private func fetchSpreadsheets() {
        let query = GTLQueryDrive.queryForFilesList()
        query.q = "mimeType='application/vnd.google-apps.spreadsheet'"
        query.orderBy = "name"
        query.fields = "nextPageToken, files(id, name)"
        gdriveService.executeQuery(query, delegate: self, didFinishSelector: #selector(displayDriveFileListWithTicket(_:finishedWithDriveFileList:error:)))
    }

    // Process the response and display file list.
    func displayDriveFileListWithTicket(ticket: GTLServiceTicket, finishedWithDriveFileList fileList: GTLDriveFileList?, error: NSError?) {
        if let error = error {
            showAlert("Error", message: error.localizedDescription)
        } else {
            if let files = fileList?.files where !files.isEmpty {
                for file in files as! [GTLDriveFile] {
                    deks.append(Dek(gDriveID: file.identifier, name: file.name, questions: []))
                }
                tableView.reloadData()
            } else {
                showAlert("Info", message: "No spreadsheets found in google drive, add some and then try again.")
            }
        }
    }


    // MARK: - GTMOAuth2

    // Creates the auth controller for authorizing access to Drive API.
    private func createAuthController() -> GTMOAuth2ViewControllerTouch {
        let controller = GTMOAuth2ViewControllerTouch(
            scope: scopes.joinWithSeparator(" "),
            clientID: gDriveClientId,
            clientSecret: nil,
            keychainItemName: gDriveKeychainItemName,
            delegate: self,
            finishedSelector: #selector(viewController(_:finishedWithAuth:error:))
        )

        return controller
    }

    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.Default,
            handler: nil
        )
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
    }


    // Handle completion of the authorization process, and updates the Drive with the new credentials.
    func viewController(viewController: GTMOAuth2ViewControllerTouch , finishedWithAuth authResult: GTMOAuth2Authentication , error: NSError? ) {
        if let error = error  {
            showAlert("Authentication Error", message: error.localizedDescription)
            gdriveService.authorizer = nil
        } else {
            gdriveService.authorizer = authResult
            dismissViewControllerAnimated(true, completion: nil)
        }
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deks.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "DekTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)

        let dek = deks[indexPath.row]
        cell.textLabel!.text = dek.name

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dek = deks[indexPath.row]
        fetchDek(dek)
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
