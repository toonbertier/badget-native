//
//  FBLoginView.swift
//  Badget
//
//  Created by Toon Bertier on 30/05/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class FBLoginView: UIView {
    
    var loginButton:FBSDKLoginButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loginButton = FBSDKLoginButton()
        self.addSubview(loginButton)
        self.loginButton.center = self.center
        self.loginButton.readPermissions = ["email", "user_friends"]
        
        let friendsButton = UIButton(frame: CGRectMake(self.center.x-100, self.center.y + 50, 200, 44))
        friendsButton.setTitle("Get my friends!", forState: .Normal)
        friendsButton.backgroundColor = UIColor.grayColor()
        friendsButton.addTarget(self, action: "getFriends", forControlEvents: .TouchUpInside)
        self.addSubview(friendsButton)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showWelcomeLabel(name:String?) {
        
        println("naam gebruiken")
        
        let welcomeLabel = UILabel(frame: CGRectMake(self.center.x - 100, self.center.y - 60, 200, 44))
        welcomeLabel.textAlignment = .Center
        if let nameUnwrapped = name {
            welcomeLabel.text = "Welcome " + nameUnwrapped + "!"
        } else {
            welcomeLabel.text = "Welcome!"
        }
        self.addSubview(welcomeLabel)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
