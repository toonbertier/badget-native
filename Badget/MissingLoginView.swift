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
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.loginButton = FBSDKLoginButton()
        self.addSubview(loginButton)
        self.loginButton.center = self.center
        self.loginButton.readPermissions = ["email", "user_friends"]
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
