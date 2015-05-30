//
//  fbLoginController.swift
//  Badget
//
//  Created by Toon Bertier on 30/05/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class fbLoginController: UIViewController, FBSDKLoginButtonDelegate {
    
    var loginManager = FBSDKLoginManager()
    var userName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let loginView = FBSDKLoginButton()
        self.view.addSubview(loginView)
        loginView.center = self.view.center
        loginView.readPermissions = ["email", "user_friends"]
        loginView.delegate = self
        
        let friendsButton = UIButton(frame: CGRectMake(self.view.center.x-100, self.view.center.y + 50, 200, 44))
        friendsButton.setTitle("Get my friends!", forState: .Normal)
        friendsButton.backgroundColor = UIColor.grayColor()
        friendsButton.addTarget(self, action: "getFriends", forControlEvents: .TouchUpInside)
        self.view.addSubview(friendsButton)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if ((error) != nil) {
            println(error.description)
        }
        else if result.isCancelled {
            println("login was cancelled")
        }
        else {
            if (result.grantedPermissions.contains("email") && result.grantedPermissions.contains("user_friends")){
                println("permissions ok and user is logged in")
                showWelcomeLabel(getUserName())
            } else if (!result.grantedPermissions.contains("user_friends")) {
                println("permission for friends NOT granted")
                showFriendPermissionAlert()
            }
        }
    }
    
    func showFriendPermissionAlert() {
        
        let alert = UIAlertController(title: "Voeg je vrienden toe", message: "Alleen wanneer je je vrienden toevoegt, zullen ze je kunnen terugvinden indien je vermist bent!", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Vrienden toelaten", style: .Default, handler: { (action) -> Void in
            println("add-friends")
            //TODO: NSUserDefaults -> friendListAvalaible op true zetten?
        })
        let cancelAction = UIAlertAction(title: "Niet toelaten", style: .Cancel, handler: { (action) -> Void in
            println("vrienden geweigerd")
            //TODO: NSUserDefaults -> friendListAvalaible op false zetten?
        })
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
        println(FBSDKProfile.currentProfile())
    }
    
    func getFriends() {
        
        var path = "/\(FBSDKAccessToken.currentAccessToken().userID)/friends"
        var token = FBSDKAccessToken.currentAccessToken().tokenString
        
        println(path + "?access_token=" + token)
        
        var friendsRequest = FBSDKGraphRequest(graphPath: path, parameters: ["access_token": token])
        friendsRequest.startWithCompletionHandler { (connection, result, error) -> Void in
            println(result)
        }
    }
    
    func getUserName() -> String? {
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        var name:String?
        
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                println("Error: \(error)")
            }
            else {
                name = result.valueForKey("name") as? String
                println("naam ontvangen")
            }
        })
        
        println("naam printen")
        return name
    }
    
    func showWelcomeLabel(name:String?) {
        
        println("naam gebruiken")
        
        let welcomeLabel = UILabel(frame: CGRectMake(self.view.center.x, self.view.center.y - 60, 200, 44))
        welcomeLabel.textAlignment = .Center
        if let nameUnwrapped = name {
            welcomeLabel.text = "Welcome " + nameUnwrapped + "!"
        } else {
            welcomeLabel.text = "Welcome!"
        }
        self.view.addSubview(welcomeLabel)
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */


}
