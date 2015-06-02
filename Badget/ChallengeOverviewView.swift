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
    weak var delegate:ChallengeOverviewViewDelegate?
    
    override init(frame: CGRect) {
        
        self.scrollView = UIScrollView(frame: CGRectMake(0, 0, frame.width, frame.height))
        
        super.init(frame: frame)
        
        setScrollableTickets()
        
        self.scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(self.scrollView)
        
        let kaarthouderImage = UIImage(named: "kaarthouder")
        let kaarthouder = UIImageView(image: kaarthouderImage)
        kaarthouder.frame = CGRectMake(self.center.x - kaarthouderImage!.size.width/2, frame.height-kaarthouderImage!.size.height, kaarthouderImage!.size.width, kaarthouderImage!.size.height)
        self.addSubview(kaarthouder)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setScrollableTickets() {
        
        var xPos = CGFloat(0)
        
        for(var i = 0; i <= 2; i++) {
            
            let image = UIImage(named: "kaart")
            var imageView = UIImageView(image: image!)
            imageView.frame = CGRectMake(CGFloat(xPos + 80), 20, image!.size.width, image!.size.height)
            imageView.userInteractionEnabled = true
            imageView.tag = i
            
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeDownHandler:")
            swipeDownRecognizer.direction = UISwipeGestureRecognizerDirection.Down
            imageView.addGestureRecognizer(swipeDownRecognizer)
            
            let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeUpHandler:")
            swipeUpRecognizer.direction = UISwipeGestureRecognizerDirection.Up
            imageView.addGestureRecognizer(swipeUpRecognizer)
            
            xPos += CGFloat(frame.width-110)
            self.scrollView.addSubview(imageView)
        }
        
        self.scrollView.contentSize = CGSizeMake(xPos+110, 0)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func swipeDownHandler(sender:UISwipeGestureRecognizer) {
        
        var ticket = sender.view!
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            ticket.center = CGPointMake(ticket.center.x, 350)
        }) { (completion) -> Void in
            self.delegate?.didChooseChallenge(self.challengeNames[sender.view!.tag])
        }
        
        self.scrollView.scrollEnabled = false
        
        
    }
    
    func swipeUpHandler(sender:UISwipeGestureRecognizer) {
        
        var ticket = sender.view!
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            ticket.center = CGPointMake(ticket.center.x, 135)
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
