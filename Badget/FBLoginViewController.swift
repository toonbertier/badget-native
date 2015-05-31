//
//  FBLoginViewController.swift
//  Badget
//
//  Created by Toon Bertier on 30/05/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire

class FBLoginViewController: UIViewController, FBSDKLoginButtonDelegate, TutorialContent {
    
    var loginManager = FBSDKLoginManager()
    var userName:String? {
        didSet {
            NSUserDefaults.standardUserDefaults().setValue(self.userName, forKey: "userName")
        }
    }
    var facebookId:String? {
        didSet {
            NSUserDefaults.standardUserDefaults().setValue(self.facebookId, forKey: "facebookId")
        }
    }
    var pageIndex:Int!
    var theView:FBLoginView {
        get{
            return self.view as! FBLoginView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.theView.loginButton.delegate = self
        
        let friendsButton = UIButton(frame: CGRectMake(self.view.center.x-100, self.view.center.y + 50, 200, 44))
        friendsButton.setTitle("Get my friends!", forState: .Normal)
        friendsButton.backgroundColor = UIColor.grayColor()
        friendsButton.addTarget(self, action: "getFriends", forControlEvents: .TouchUpInside)
        self.view.addSubview(friendsButton)
    }
    
    override func loadView() {
        self.view = FBLoginView(frame: UIScreen.mainScreen().bounds)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if ((error) != nil) {
            println(error.description)
            self.theView.showErrorLabel()
        }
        else {
            if (result.grantedPermissions.contains("email") && result.grantedPermissions.contains("user_friends")){
                println("permissions ok and user is logged in")
                setUser()
            } else if (!result.grantedPermissions.contains("user_friends")) {
                showFriendPermissionAlert()
            }
        }
    }
    
    func showFriendPermissionAlert() {
        
        let alert = UIAlertController(title: "Voeg je vrienden toe", message: "Alleen wanneer je je vrienden toevoegt, zullen ze je kunnen terugvinden indien je vermist bent!", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
            println("add-friends")
            self.reAuthorizeFriends()
            //TODO: NSUserDefaults -> friendListAvalaible op true zetten?
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            println("vrienden geweigerd")
            //TODO: NSUserDefaults -> friendListAvalaible op false zetten?
        })
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func reAuthorizeFriends() {
        FBSDKLoginManager().logInWithReadPermissions(["user_friends"], handler: { (result: FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
            println(result)
        })
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userName")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("facebookId")
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
    
    func setUser() {
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        var name:String?
        
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                println("Error: \(error)")
            }
            else {
                self.userName = result.valueForKey("name") as? String
                self.facebookId = result.valueForKey("id") as? String
                self.uploadUserToDatabase()
            }
        })
    }
    
    func uploadUserToDatabase() {
        if let user = self.userName {
            if let id = self.facebookId {
                Alamofire.request(.POST, "http://student.howest.be/toon.bertier/20142015/MA4/BADGET/api/users", parameters: ["name": user, "facebook_id": id])
                         .response { (request, response, data, error) in
                            if(response?.statusCode == 200) {
                                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "userIsUploaded")
                            } else {
                                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "userIsUploaded")
                            }
                        }
                }
        }
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
