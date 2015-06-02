//
//  ChallengeExplanationView.swift
//  Badget
//
//  Created by Toon Bertier on 02/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

protocol ChallengeExplanationViewDelegate:class {
    func didStartChallenge()
}

class ChallengeExplanationView: UIView {
    
    weak var delegate:ChallengeExplanationViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        let expLabel = UILabel(frame: CGRectMake(self.center.x - 50, self.center.y - 100, 100, 44))
        expLabel.textAlignment = .Center
        expLabel.text = "uitleg uitleg"
        self.addSubview(expLabel)
        
        let startButton = UIButton(frame: CGRectMake(self.center.x-75, self.center.y+50, 150, 44))
        startButton.backgroundColor = UIColor.redColor()
        startButton.setTitle("Start challenge", forState: .Normal)
        startButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        startButton.addTarget(self, action: "tappedStart:", forControlEvents: .TouchUpInside)
        self.addSubview(startButton)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tappedStart(sender:UIButton) {
        self.delegate?.didStartChallenge()
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
