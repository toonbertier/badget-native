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
import CoreData

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

class FBLoginViewController: UIViewController, FBSDKLoginButtonDelegate, TutorialContent, PTPusherDelegate {
    
    var loginManager = FBSDKLoginManager()
    var pageIndex:Int!
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
    var viewToLoad:FBLoginViews!
    var theView:BadgetLoginView {
        get{
            return self.view as! BadgetLoginView
        }
    }
    var appDelegate:AppDelegate {
        get {
            return UIApplication.sharedApplication().delegate as! AppDelegate
        }
    }
    
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
        }
        
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
                FBLoginViewController.subscribeToFriendEvents()
                
                if(viewToLoad! == .MissingLoginView) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
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
    
    class func subscribeToFriendEvents() {
        
        var path = "/\(FBSDKAccessToken.currentAccessToken().userID)/friends"
        var token = FBSDKAccessToken.currentAccessToken().tokenString
        
        //request naar Graph API van Facebook om vrienden op te halen
        var friendsRequest = FBSDKGraphRequest(graphPath: path, parameters: ["access_token": token])
        friendsRequest.startWithCompletionHandler { (connection, result, error) -> Void in
            
            if(result != nil) {
                if let resultUnwrapped:AnyObject = result {
                    FBLoginViewController.subscribeToFriendEventsCompletionHandler(result)
                }
            }
            if(error != nil) {
                println(error.description)
            }
            
        }
        
    }
    
    class func subscribeToFriendEventsCompletionHandler(result:AnyObject) {
        
        let data = result["data"] as! NSArray
        
        for friend in data {
            
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
            
            /*
            //save PusherEvent naar coreData voor background notificaties
            
            let pusherEventEntity = NSEntityDescription.entityForName("PusherEvent", inManagedObjectContext: appDelegate.managedObjectContext!)
            let pusherEvent = NSManagedObject(entity: pusherEventEntity!, insertIntoManagedObjectContext: appDelegate.managedObjectContext!)
            pusherEvent.setValue(eventName, forKey: "eventName")
            */
            
        }
        
        /*
        var error: NSError?
        if !appDelegate.managedObjectContext!.save(&error) {
        println("could not save: \(error?.userInfo)")
        }
        */
        
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
