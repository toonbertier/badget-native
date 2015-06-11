//
//  ChallengeOverviewView.swift
//  Badget
//
//  Created by Toon Bertier on 02/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

protocol ChallengeOverviewViewDelegate:class {
    func didChooseChallenge(name:ChallengeName)
}

class ChallengeOverviewView: UIView, UIGestureRecognizerDelegate {
    
    let scrollView:UIScrollView
    let challengeNames:Array<ChallengeName> = [.StraightLine, .CrowdSurfing, .Quiz]
    let cardNames = ["rechte-lijn-kaart", "geniet-rit-kaart", "wikken-wegen-kaart"]
    var cardWidth:CGFloat!
    weak var delegate:ChallengeOverviewViewDelegate?
    
    override init(frame: CGRect) {
    
        self.scrollView = UIScrollView(frame: CGRectMake(0, 0, frame.width, frame.height))
        
        super.init(frame: frame)
        
        self.addSubview(UIImageView(image: UIImage(named: "white-bg")!))
        
        setScrollableTickets()
        self.scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(self.scrollView)
        
        showCardHolder()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showCardHolder() {
        let kaarthouderImage = UIImage(named: "kaarthouder")
        let kaarthouder = UIImageView(image: kaarthouderImage)
        kaarthouder.frame = CGRectMake(self.center.x - kaarthouderImage!.size.width/2, 385, kaarthouderImage!.size.width, kaarthouderImage!.size.height)
        self.addSubview(kaarthouder)
        self.bringSubviewToFront(kaarthouder)
    }
    
    func setScrollableTickets() {
        
        var xPos = CGFloat(87)
        
        for(var i = 0; i <= 2; i++) {
            
            let image = UIImage(named: self.cardNames[i])
            var imageView = UIImageView(image: image!)
            imageView.frame = CGRectMake(xPos, 90, image!.size.width, image!.size.height)
            imageView.userInteractionEnabled = true
            imageView.tag = i
            
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeDownHandler:")
            swipeDownRecognizer.direction = UISwipeGestureRecognizerDirection.Down
            imageView.addGestureRecognizer(swipeDownRecognizer)
            
            let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeUpHandler:")
            swipeUpRecognizer.direction = UISwipeGestureRecognizerDirection.Up
            imageView.addGestureRecognizer(swipeUpRecognizer)
            
            xPos += CGFloat(image!.size.width + 50)
            self.scrollView.addSubview(imageView)
            
            if(i == 2) {
                self.cardWidth = image!.size.width
            }
        }
        
        self.scrollView.contentSize = CGSizeMake(xPos + 38, 0)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func swipeDownHandler(sender:UISwipeGestureRecognizer) {
        
        var ticket = sender.view!
        var centerX:CGFloat!
        
        if(self.scrollView.contentOffset.x >= 0 && self.scrollView.contentOffset.x < 95) {
            println("eerste kaart")
            centerX = 87 + cardWidth/2
        } else if(self.scrollView.contentOffset.x > 95 && self.scrollView.contentOffset.x < 290) {
            println("tweede kaart")
            centerX = 135 + cardWidth*1.5
        } else {
            println("derde kaart")
            centerX = 168 + cardWidth*2.5
        }
        
        println(centerX)
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            ticket.center = CGPointMake(centerX, 390)
        }) { (completion) -> Void in
            self.delegate?.didChooseChallenge(self.challengeNames[sender.view!.tag])
        }
        
        self.scrollView.scrollEnabled = false
        
        
    }
    
    func swipeUpHandler(sender:UISwipeGestureRecognizer) {
        
        var ticket = sender.view!
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            ticket.center = CGPointMake(ticket.center.x, 205)
        })
        
        self.scrollView.scrollEnabled = true
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
