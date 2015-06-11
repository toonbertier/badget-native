//
//  MissingLoginView.swift
//  Badget
//
//  Created by Toon Bertier on 04/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class MissingLoginView: UIView, BadgetLoginView {
    
    var loginButton:FBSDKLoginButton!
    var popViewControllerAfterLogin = true
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(UIImageView(image: UIImage(named: "white-bg")!))
        
        showText()
        showIllustration()
        showLoginButton()
        showDetailButton()
        showGoBackButton()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showText() {
        let titleLabel = BadgetUI.makeTitle("JE VRIENDEN KWIJT?")
        titleLabel.center = CGPointMake(self.center.x, 90)
        self.addSubview(titleLabel)
        
        let descrLabel = BadgetUI.makeDescription("Ben je je vrienden kwijtgespeeld? Geen nood! Stuur een snel berichtje naar al je vrienden of zoek in de lijst naar je verloren kameraad!", width:250, highlights: ["snel berichtje", "zoek in de lijst"])
        descrLabel.center = CGPointMake(self.center.x, 150)
        self.addSubview(descrLabel)
    }
    
    func showIllustration() {
        let image = UIImage(named: "missing-login-illustration")
        let imageView = UIImageView(image: image!)
        imageView.center = CGPointMake(self.center.x, self.center.y + 20)
        self.addSubview(imageView)
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
    
    func showGoBackButton() {
        let goBackButton = BadgetUI.makeButton("TOCH NIET", center: CGPointMake(self.center.x, 520), width: 100)
        goBackButton.addTarget(self, action: "goBackButtonTapped:", forControlEvents: .TouchUpInside)
        self.addSubview(goBackButton)
    }
    
    func goBackButtonTapped(sender:UIButton) {
        println("go back")
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
