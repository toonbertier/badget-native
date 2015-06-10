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
        
        let titleLabel = BadgetUI.makeTitle("De Lijn maakt van jou een echte festivalganger!")
        titleLabel.center = CGPointMake(self.center.x, self.center.y - 220)
        self.addSubview(titleLabel)
        
        let descrLabel = BadgetUI.makeDescription("Je eerste festival, je wilt een beleving om nooit te vergeten maar je voelt je wat onvoorbereid... Geen probleem! De Lijn is er om je op weg te helpen! Doe challenges, win gadgets en wordt een echte festivalganger!", highlights: ["Doe challenges", "win gadgets"])
        descrLabel.center = CGPointMake(self.center.x, self.center.y - 120)
        self.addSubview(descrLabel)
    }
    
    func showLoginButton() {
        self.loginButton = FBSDKLoginButton()
        self.addSubview(loginButton)
        self.loginButton.center = CGPointMake(self.center.x, 460)
        self.loginButton.readPermissions = ["email", "user_friends"]
    }
    
    func showDetailButton() {
        let detailButton = BadgetUI.makeDetailButton()
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
        let errorLabel = BadgetUI.makeErrorLabel("Er ging iets mis, probeer opnieuw")
        errorLabel.center = CGPointMake(self.center.x, 485)
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
