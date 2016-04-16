//
//  FlashcardViewController.swift
//  flipflop
//
//  Created by Michelle Harvey on 4/16/16.
//  Copyright © 2016 Michelle Venetucci Harvey. All rights reserved.
//

import Foundation
import UIKit

class FlashcardViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    
    var cardView: UIView!
    var front: UIView!
    var back: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flashcardStyles()
        
        backgroundView.backgroundColor = UIColor.lightGrayColor()
    }
    
    func tapped() {
        var showingSide = front
        var hiddenSide = back
        var showingBack = true
        
        if showingBack {
            (showingSide, hiddenSide) = (back, front)
        }
        
        UIView.transitionFromView(showingSide, toView: hiddenSide, duration: 0.6, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
        
        showingBack = !showingBack
        
    }
    
    override func viewWillLayoutSubviews() {
        cardView.center = view.center
    }

    func flashcardStyles() {
        let width = self.view.frame.width * 0.85
        let height = self.view.frame.height * 0.85
        let y = self.view.frame.minY - 10.0
        let rect = CGRectMake(0, y, width, height)
        
        let singleTap = UITapGestureRecognizer(target: self, action: "tapped")
        singleTap.numberOfTapsRequired = 1
        
        front = UIView(frame: rect)
        front.backgroundColor = UIColor.whiteColor()
        front.layer.cornerRadius = 16
        front.layer.shadowColor = UIColor.blackColor().CGColor
        front.layer.shadowOpacity = 0.2
        front.layer.shadowOffset = CGSizeZero
        front.layer.shadowRadius = 16
        
        back = UIView(frame: rect)
        back.backgroundColor = UIColor.whiteColor()
        back.layer.cornerRadius = 16
        back.layer.shadowColor = UIColor.blackColor().CGColor
        back.layer.shadowOpacity = 0.2
        back.layer.shadowOffset = CGSizeZero
        back.layer.shadowRadius = 16
        
        cardView = UIView(frame: rect)
        cardView.addGestureRecognizer(singleTap)
        cardView.userInteractionEnabled = true
        cardView.addSubview(back)
        self.view.addSubview(cardView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

