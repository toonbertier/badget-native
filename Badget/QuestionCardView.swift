//
//  QuestionCardView.swift
//  Badget
//
//  Created by Toon Bertier on 10/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

class QuestionCardView: UIView {
    
    var data:Question!
    var answer:Bool!
    
    init(frame:CGRect, data:Question) {
        super.init(frame: frame)
        
        self.data = data
        self.answer = data.answer
        
        let degr = arc4random_uniform(3)
        println(degr)
        let rads = radiansToDegrees(Double(degr))
        //self.transform = CGAffineTransformMakeRotation(rads);
        
        renderQuestionLabel()
    }
    
    func renderQuestionLabel() {
        
        let bgImage = UIImage(named: "fb-info-bg")
        let bg = UIImageView(frame: self.frame)
        bg.center = CGPointMake(self.center.x, self.center.y)
        bg.image = bgImage
        bg.contentMode = UIViewContentMode.Center
        self.addSubview(bg)
        
        let questionLabel = BadgetUI.makeDescription(self.data.question, width: 140,highlights: [])
        questionLabel.center = CGPointMake(self.center.x, self.center.y)
        self.addSubview(questionLabel)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func radiansToDegrees (value:Double) -> Double {
        return value * 180.0 / M_PI
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
