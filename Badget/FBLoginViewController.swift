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
import Pusher

enum FBLoginViews {
    
    case FBTutorialLoginView
    case MissingLoginView
    
}

protocol BadgetLoginView {
    
    init(frame:CGRect)
    func showErrorLabel()
    var loginButton:FBSDKLoginButton! {get set}
    var popViewControllerAfterLogin:Bool {get}
    
}

protocol FBLoginViewControllerDelegate:class {
    func doDismissViewController()
}

class FBLoginViewController: UIViewController, FBSDKLoginButtonDelegate, MissingLoginViewDelegate, TutorialContent, PTPusherDelegate {
    
    var loginManager = FBSDKLoginManager()
    var pageIndex:Int!
    var viewToLoad:FBLoginViews!
    var theView:BadgetLoginView {
        get{
            return self.view as! BadgetLoginView
        }
    }
    var missingLoginView:MissingLoginView {
        get {
            return self.view as! MissingLoginView
        }
    }
    var appDelegate:AppDelegate {
        get {
            return UIApplication.sharedApplication().delegate as! AppDelegate
        }
    }
    weak var delegate:FBLoginViewControllerDelegate?
    
    init(viewToLoad:FBLoginViews) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewToLoad = viewToLoad
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.theView.loginButton.delegate = self
        
    }
    
    override func loadView() {
        
        switch viewToLoad! {
            
            case .FBTutorialLoginView:
                self.view = FBTutorialLoginView(frame: UIScreen.mainScreen().bounds)
            case .MissingLoginView:
                self.view = MissingLoginView(frame: UIScreen.mainScreen().bounds)
                self.missingLoginView.delegate = self
        }
        
    }
    
    func didSelectDismissViewController() {
        println("tapped dismiss")
        self.delegate?.doDismissViewController()
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
        else if (result.isCancelled) {
            if(viewToLoad == .MissingLoginView) {
                self.delegate?.doDismissViewController()
            }
        }
        else {
            if (result.grantedPermissions.contains("email") && result.grantedPermissions.contains("user_friends")){
                println("permissions ok and user is logged in")
                FBLoginViewController.uploadUserToDatabase()
                FBLoginViewController.doActionOnFacebookFriends(FBLoginViewController.subscribeToFriendEvents)
                
                if(viewToLoad! == .MissingLoginView) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("user logged out with facebook")
    }
    
    class func uploadUserToDatabase() {
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        var name:String?
        
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                println("Error: \(error)")
            }
            else {
                var userName = result.valueForKey("name") as? String
                var facebookId = result.valueForKey("id") as? String
                FBLoginViewController.uploadUserToDatabaseHandler(userName, facebookId: facebookId)
            }
        })
    }
    
    class func uploadUserToDatabaseHandler(userName:String?, facebookId:String?) {
        
        if let user = userName {
            if let id = facebookId {
                
                var params = ["name": user, "facebook_id": id, "device_id": UIDevice.currentDevice().identifierForVendor.UUIDString]
                
                Alamofire.request(.POST, "http://student.howest.be/toon.bertier/20142015/MA4/BADGET/api/users", parameters: params)
                         .response { (request, response, data, error) in
                            if(response?.statusCode == 200) {
                                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "userIsInDatabase")
                                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "userIsMissing")
                            } else {
                                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "userIsInDatabase")
                            }
                        }
                }
        }
    }
    
    class func showFriendPermissionAlert(viewControllerToPresentOn viewController:UIViewController) {
        
        let alert = UIAlertController(title: "Voeg je vrienden toe", message: "Alleen wanneer je je vrienden toevoegt, zullen ze je kunnen terugvinden indien je vermist bent!", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
            println("add-friends")
            FBLoginViewController.reAuthorizeFriends()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            println("vrienden geweigerd")
        })
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func reAuthorizeFriends() {
        FBSDKLoginManager().logInWithReadPermissions(["user_friends"], handler: { (result: FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
            println(result)
        })
    }
    
    class func doActionOnFacebookFriends(handler: (NSArray) -> Void) {
        
        var path = "/\(FBSDKAccessToken.currentAccessToken().userID)/friends"
        var token = FBSDKAccessToken.currentAccessToken().tokenString
        
        //request naar Graph API van Facebook om vrienden op te halen
        var friendsRequest = FBSDKGraphRequest(graphPath: path, parameters: ["access_token": token])
        friendsRequest.startWithCompletionHandler { (connection, result, error) -> Void in
            
            if(result != nil) {
                if let resultUnwrapped:AnyObject = result {
                    handler(result["data"] as! NSArray)
                }
            }
            if(error != nil) {
                println(error.description)
            }
            
        }
        
    }
    
    class func subscribeToFriendEvents(friends:NSArray) {
        
        for friend in friends {
            
            //notificatie wanneer de app openstaat
            let eventName = friend.valueForKey("id") as! String + "Missing"
            println("binding to: " + eventName)
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.pusherChannel.bindToEventNamed(eventName, handleWithBlock: { (channelEvent) -> Void in
                
                println("notification received!")
                
                var localNotification = UILocalNotification()
                localNotification.category = "missingCategory";
                localNotification.alertAction = "Unlock"
                localNotification.alertBody = channelEvent.data["message"] as? String
                localNotification.fireDate = NSDate(timeIntervalSinceNow: 0)
                UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                
            })
            
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
