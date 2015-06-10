//
//  BadgetUI.swift
//  Badget
//
//  Created by Toon Bertier on 10/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

class BadgetUI: NSObject {
    
    //LABELS
    
    class func makeTitle(title:String) -> UILabel {
        
        let titleTxt = title as NSString
        let font1 = UIFont(name: "Dosis-SemiBold", size: 20)
        let boundingRect = titleTxt.boundingRectWithSize(CGSizeMake(250, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font1!], context: nil)
        let titleLabel = UILabel(frame: CGRectMake(0,0,boundingRect.size.width,boundingRect.size.height))
        titleLabel.text = titleTxt as String
        titleLabel.font = font1
        titleLabel.textAlignment = .Center
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        
        return titleLabel
    }
    
    class func makeDescription(text:String, highlights:Array<String>) -> UILabel {
        
        let descrString = text as NSString
        let descrAttrTxt = NSMutableAttributedString(string: descrString as String)
        let yellow = UIColor(red: 0.93, green: 0.84, blue: 0.38, alpha: 0.8)
        for highlight in highlights {
            let range = descrString.rangeOfString(highlight)
            descrAttrTxt.addAttribute(NSBackgroundColorAttributeName, value: yellow, range: range)
        }
        let font = UIFont(name: "AvenirNext-Regular", size: 14)
        let boundingRect = descrString.boundingRectWithSize(CGSizeMake(250, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font!], context: nil)
        let descrLabel = UILabel(frame: CGRectMake(0,0,boundingRect.size.width,boundingRect.size.height))
        descrLabel.attributedText = descrAttrTxt
        descrLabel.font = font
        descrLabel.textAlignment = .Center
        descrLabel.numberOfLines = 0
        descrLabel.sizeToFit()
        
        return descrLabel
    }
    
    class func makeErrorLabel(text:String) -> UILabel {
        
        let errorLabel = UILabel(frame: CGRectMake(0, 0, 200, 44))
        let font = UIFont(name: "AvenirNext-Regular", size: 12)
        errorLabel.textAlignment = .Center
        errorLabel.textColor = UIColor(red: 0.94, green: 0.42, blue: 0.30, alpha: 1)
        errorLabel.text = text
        errorLabel.font = font
        return errorLabel
    }
    
    //BUTTONS
        
    class func makeButton(title:String, center:CGPoint, width:CGFloat) -> UIButton {
            
        let button = UIButton(frame: CGRectMake(0, 0, width, 45))
        button.setBackgroundImage(UIImage(named: "button-bg")!, forState: .Normal)
        button.setTitle(title, forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.titleLabel!.font = UIFont(name: "Dosis-SemiBold", size: 20)
        button.center = center
        return button
    }
    
    class func makeDetailButton() -> UIButton {
        let detailButton = UIButton(frame: CGRectMake(0, 0, 26, 30))
        detailButton.setBackgroundImage(UIImage(named: "detail-button")!, forState: .Normal)
        return detailButton
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
}
