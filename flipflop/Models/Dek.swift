//
//  Dek.swift
//  flipflop
//
//  Created by Julian Tescher on 7/5/16.
//  Copyright © 2016 Michelle Venetucci Harvey. All rights reserved.
//

import UIKit

class Dek {

    // MARK: Properties
    let gDriveID: String
    let name: String
    let questions: [Question]

    init(gDriveID: String, name: String, questions: [Question]) {
        self.gDriveID = gDriveID
        self.name = name
        self.questions = questions
    }
    
}
