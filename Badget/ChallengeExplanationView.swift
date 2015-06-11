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
    
    var data:ChallengeExplanation!
    weak var delegate:ChallengeExplanationViewDelegate?
    
    init(frame: CGRect, data:ChallengeExplanation) {
        super.init(frame: frame)
        
        self.addSubview(UIImageView(image: UIImage(named: "white-bg")!))
        self.data = data
        
        showExpImage()
        showExpDescr()
        showSteps()
        showStartButton()
    }
    
    func showExpImage() {
        let image = UIImage(named: "\(self.data.image)")
        let imageView = UIImageView(image: image!)
        imageView.center = CGPointMake(self.center.x, 150)
        self.addSubview(imageView)
    }
    
    func showExpDescr() {
        let descrLabel = BadgetUI.makeDescription(self.data.descr, width:250, highlights: [])
        descrLabel.center = CGPointMake(self.center.x, self.center.y - 20)
        self.addSubview(descrLabel)
    }
    
    func showSteps() {
        let labels = BadgetUI.makeList([self.data.stap1, self.data.stap2, self.data.stap3])
        for (i, label) in enumerate(labels) {
            label.center = CGPointMake(self.center.x, self.center.y + 70 + CGFloat(i*30))
            self.addSubview(label)
        }
    }
    
    func showStartButton() {
        let startButton = BadgetUI.makeButton("START", center: CGPointMake(self.center.x, self.center.y + 190), width: 100)
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
