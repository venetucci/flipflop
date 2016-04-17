//
//  FlashcardViewController.swift
//  flipflop
//
//  Created by Michelle Harvey on 4/16/16.
//  Copyright © 2016 Michelle Venetucci Harvey. All rights reserved.
//

import Foundation
import UIKit
import SwiftHEXColors

class FlashcardViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    
    var cardView: UIView!
    var front: UIView!
    var back: UIView!
    
    let blue = UIColor(hexString: "#43DAF8")!
    let green = UIColor(hexString: "#7AEA7A")!
    let red = UIColor(hexString: "#F96B54")!
    let white = UIColor(hexString: "FFFFFF")!
    let black = UIColor(hexString: "171616")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flashcardStyles()
        
        backgroundView.backgroundColor = blue
        
        // The onCustomPan: method will be defined in Step 3 below.
        var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onCustomPan:")
       
//        cardStart = CGPoint(x: cardView.center.x, y: cardView.center.y + cardDownOffset)
        
        // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
        cardView.userInteractionEnabled = true
        cardView.addGestureRecognizer(panGestureRecognizer)
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
    
    func onCustomPan(sender: UIPanGestureRecognizer) {
        let point = sender.locationInView(view)
        let velocity = sender.velocityInView(view)
        let translation = sender.translationInView(view)
        
        var cardInitialCenter: CGPoint!
        
        cardInitialCenter = cardView.center
        
        if sender.state == UIGestureRecognizerState.Began {
            print("Gesture began at: \(point)")
        } else if sender.state == UIGestureRecognizerState.Changed {
            cardView.center = CGPoint(x: cardInitialCenter.x + translation.x, y: cardInitialCenter.y)
            self.cardView.transform = CGAffineTransformMakeRotation(CGFloat(translation.x * 15 / 160 * CGFloat(M_PI) / 180))

            print("Gesture changed at: \(point)")
            print("center.x: \(cardInitialCenter.x + translation.x)")
            
            if point.x > 150 {
                UIView.animateWithDuration(0.4, animations: {
                    self.backgroundView.backgroundColor = self.green
                })
            } else if point.x < 100 {
                UIView.animateWithDuration(0.4, animations: {
                    self.backgroundView.backgroundColor = self.red
                })
            }

        } else if sender.state == UIGestureRecognizerState.Ended {
            if translation.x > -40 && translation.x < 50 {
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.cardView.center.x = 160
                    self.cardView.transform = CGAffineTransformIdentity
                })
            } else if translation.x > 51 {
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.cardView.center.x = 1000
                })
            } else {
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.cardView.center.x = -1000
                })
            }
            print("Gesture ended at: \(point)")
        }
    }
    
    override func viewWillLayoutSubviews() {
        cardView.center = view.center
    }

    func flashcardStyles() {
        let width = self.view.frame.width * 0.85
        let height = self.view.frame.height * 0.55
        let y = self.view.frame.minY
        let rect = CGRectMake(0, y, width, height)
        
        let singleTap = UITapGestureRecognizer(target: self, action: "tapped")
        singleTap.numberOfTapsRequired = 1
        
        front = UIView(frame: rect)
        front.backgroundColor = white
        front.layer.cornerRadius = 16
        front.layer.shadowColor = black.CGColor
        front.layer.shadowOpacity = 0.2
        front.layer.shadowOffset = CGSizeZero
        front.layer.shadowRadius = 16
        
        back = UIView(frame: rect)
        back.backgroundColor = white
        back.layer.cornerRadius = 16
        back.layer.shadowColor = black.CGColor
        back.layer.shadowOpacity = 0.2
        back.layer.shadowOffset = CGSizeZero
        back.layer.shadowRadius = 16
        
        cardView = UIView(frame: rect)
        cardView.addGestureRecognizer(singleTap)
        cardView.userInteractionEnabled = true
        cardView.addSubview(back)
        self.view.addSubview(cardView)
        
        // card content
        
        let textWidth = self.view.frame.width - 110
        let textHeight = self.view.frame.height - 60
        let textY = self.view.frame.minY + 30
        let textX = self.view.frame.minX + 30
        let bodyLabel = UILabel(frame: CGRectMake(textX, textY, textWidth, textHeight))
        let bodyFontOne = UIFont(name:"Avenir", size: 28.0)
        
        bodyLabel.text = "sample text here this is a whole sentence"
        bodyLabel.textColor = black
        bodyLabel.font = bodyFontOne
        bodyLabel.textAlignment = NSTextAlignment.Center
        bodyLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        bodyLabel.numberOfLines = 0
        bodyLabel.contentMode = UIViewContentMode.ScaleAspectFit
        bodyLabel.sizeToFit()
        cardView.addSubview(bodyLabel)
        
        let bodyHeight = bodyLabel.bounds.height
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

