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
    var cardInitialCenter: CGPoint!
    var showingSide: UIView!
    var hiddenSide: UIView!
    
    let blue = UIColor(hexString: "#43DAF8")!
    let green = UIColor(hexString: "#7AEA7A")!
    let red = UIColor(hexString: "#F96B54")!
    let white = UIColor(hexString: "FFFFFF")!
    let black = UIColor(hexString: "171616")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flashcardStyles()
        
        backgroundView.backgroundColor = blue
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onCustomPan:")
        
        cardView.userInteractionEnabled = true
        cardView.addGestureRecognizer(panGestureRecognizer)
        
        cardInitialCenter = cardView.center
        
        showingSide = front
        hiddenSide = back
        
    }
    
    func tapped() {
        
        (showingSide, hiddenSide) = (hiddenSide, showingSide)
        
        UIView.transitionFromView(showingSide, toView: hiddenSide, duration: 0.6, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
        
        print(showingSide.backgroundColor)

    }
    
    func onCustomPan(sender: UIPanGestureRecognizer) {
        let point = sender.locationInView(view)
        let translation = sender.translationInView(view)
        let newtranslation = CGAffineTransformMakeTranslation(translation.x, 0)
        
        if sender.state == UIGestureRecognizerState.Began {
        } else if sender.state == UIGestureRecognizerState.Changed {
            
            let rotate = CGAffineTransformMakeRotation(CGFloat(translation.x * 15 / 160 * CGFloat(M_PI) / 180))

            self.cardView.transform = CGAffineTransformConcat(rotate, newtranslation);
            
            if point.x > 220 {
                UIView.animateWithDuration(0.4, animations: {
                    self.backgroundView.backgroundColor = self.green
                })
            } else if point.x >= 115 && point.x <= 220 {
                UIView.animateWithDuration(0.4, animations: { 
                    self.backgroundView.backgroundColor = self.blue
                })
            } else if point.x < 115 {
                UIView.animateWithDuration(0.4, animations: {
                    self.backgroundView.backgroundColor = self.red
                })
            }

        } else if sender.state == UIGestureRecognizerState.Ended {
            self.backgroundView.backgroundColor = self.blue

            if point.x > 220 {
                UIView.animateWithDuration(0.4, animations: {
                    UIView.animateWithDuration(0.4, animations: { () -> Void in
                        self.cardView.center.x = 1000
                    })
                })
            } else if point.x >= 115 && point.x <= 220 {
                UIView.animateWithDuration(0.2, animations: {
                    self.cardView.transform = CGAffineTransformIdentity
                })
            } else if point.x < 115 {
                UIView.animateWithDuration(0.4, animations: { 
                    self.cardView.center.x = -1000
                }
            )}
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
        front.backgroundColor = green
        front.layer.cornerRadius = 16
        front.layer.shadowColor = black.CGColor
        front.layer.shadowOpacity = 0.2
        front.layer.shadowOffset = CGSizeZero
        front.layer.shadowRadius = 16
        
        back = UIView(frame: rect)
        back.backgroundColor = red
        back.layer.cornerRadius = 16
        back.layer.shadowColor = black.CGColor
        back.layer.shadowOpacity = 0.2
        back.layer.shadowOffset = CGSizeZero
        back.layer.shadowRadius = 16
        
        cardView = UIView(frame: rect)
        cardView.addGestureRecognizer(singleTap)
        cardView.userInteractionEnabled = true
//        cardView.addSubview(back)
        cardView.addSubview(front)
        self.view.addSubview(cardView)
        
        // card content
        
        let textWidth = self.view.frame.width - 110
        let textHeight = self.view.frame.height - 60
        let textY = self.view.frame.minY + 30
        let textX = self.view.frame.minX + 30
        let bodyLabel = UILabel(frame: CGRectMake(textX, textY, textWidth, textHeight))
        let bodyFontOne = UIFont(name:"Avenir", size: 28.0)
        
        bodyLabel.text = "Lorem Khaled Ipsum is a major key to success. Eliptical talk."
        bodyLabel.textColor = black
        bodyLabel.font = bodyFontOne
        bodyLabel.textAlignment = NSTextAlignment.Center
        bodyLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        bodyLabel.numberOfLines = 0
        bodyLabel.contentMode = UIViewContentMode.ScaleAspectFit
        bodyLabel.sizeToFit()
        front.addSubview(bodyLabel)
        
//        let bodyHeight = bodyLabel.bounds.height
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

