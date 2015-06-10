//
//  FBTutorialLoginView.swift
//  Badget
//
//  Created by Toon Bertier on 04/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class FBTutorialLoginView: UIView, BadgetLoginView {

    var loginButton:FBSDKLoginButton!
    var popViewControllerAfterLogin = false
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(UIImageView(image: UIImage(named: "white-bg")!))
        
        showText()
        showLoginButton()
        showDetailButton()
        showIllustration()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showText() {
        
        let titleTxt = "De Lijn maakt van jou een echte festivalganger!" as NSString
        
        let font1 = UIFont(name: "Dosis-SemiBold", size: 20)
        
        Fonts.enumerateFonts()
        
        let boundingRect1 = titleTxt.boundingRectWithSize(CGSizeMake(250, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font1!], context: nil)
        
        let titleLabel = UILabel(frame: CGRectMake(60,50,boundingRect1.size.width,boundingRect1.size.height))
        titleLabel.text = titleTxt as String
        titleLabel.font = font1
        titleLabel.textAlignment = .Center
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        self.addSubview(titleLabel)
        
        let descrString = "Je eerste festival, je wilt een beleving om nooit te vergeten maar je voelt je wat onvoorbereid... Geen probleem! De Lijn is er om je op weg te helpen! Doe challenges, win gadgets en wordt een echte festivalganger!" as NSString
        let descrAttrTxt = NSMutableAttributedString(string: descrString as String)
        let range1 = descrString.rangeOfString("Doe challenges")
        let range2 = descrString.rangeOfString("win gadgets")
        
        let yellow = UIColor(red: 0.93, green: 0.84, blue: 0.38, alpha: 0.8)
        descrAttrTxt.addAttribute(NSBackgroundColorAttributeName, value: yellow, range: range1)
        descrAttrTxt.addAttribute(NSBackgroundColorAttributeName, value: yellow, range: range2)
        
        let font2 = UIFont(name: "AvenirNext-Regular", size: 14)
        
        let boundingRect2 = descrString.boundingRectWithSize(CGSizeMake(250, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font2!], context: nil)
        
        let descrLabel = UILabel(frame: CGRectMake(40,70 + boundingRect1.size.height,boundingRect2.size.width,boundingRect2.size.height))
        descrLabel.attributedText = descrAttrTxt
        descrLabel.font = font2
        descrLabel.textAlignment = .Center
        descrLabel.numberOfLines = 0
        descrLabel.sizeToFit()
        self.addSubview(descrLabel)
    }
    
    func showLoginButton() {
        self.loginButton = FBSDKLoginButton()
        self.addSubview(loginButton)
        self.loginButton.center = CGPointMake(self.center.x, 460)
        self.loginButton.readPermissions = ["email", "user_friends"]
    }
    
    func showDetailButton() {
        let detailButton = UIButton(frame: CGRectMake(0, 0, 26, 30))
        detailButton.setBackgroundImage(UIImage(named: "detail-button")!, forState: .Normal)
        detailButton.center = CGPointMake(270, 460)
        detailButton.addTarget(self, action: "detailButtonTapped:", forControlEvents: .TouchUpInside)
        self.addSubview(detailButton)
    }
    
    func detailButtonTapped(sender:UIButton) {
        let explanationView = FBExplanationView(frame: CGRectMake(0, 0, self.frame.width, self.frame.height))
        self.addSubview(explanationView)
    }
    
    func showIllustration() {
        let image = UIImage(named: "illustratie-fb")
        let imageView = UIImageView(image: image!)
        imageView.center = CGPointMake(self.center.x, 265 + image!.size.height/2)
        self.addSubview(imageView)
    }
    
    func showErrorLabel() {
        let errorLabel = UILabel(frame: CGRectMake(self.center.x - 100, self.center.y - 60, 200, 44))
        errorLabel.textAlignment = .Center
        errorLabel.text = "Er ging iets mis, probeer opnieuw"
        self.addSubview(errorLabel)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */

}
