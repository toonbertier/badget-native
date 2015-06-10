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
        
        self.backgroundColor = .grayColor()
        let degr = arc4random_uniform(3)
        println(degr)
        let rads = radiansToDegrees(Double(degr))
        //self.transform = CGAffineTransformMakeRotation(rads);
        
        renderQuestionLabel()
    }
    
    func renderQuestionLabel() {
        
        let questionTxt = self.data.question as NSString
        
        let font = UIFont(name: "HelveticaNeue", size: 14)
        
        let boundingRect = questionTxt.boundingRectWithSize(CGSizeMake(self.frame.width - 60, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font!], context: nil)
        
        let questionLabel = UILabel(frame: CGRectMake(10,10,boundingRect.size.width,boundingRect.size.height))
        questionLabel.text = questionTxt as String
        questionLabel.textAlignment = .Center
        questionLabel.numberOfLines = 0
        questionLabel.sizeToFit()
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
