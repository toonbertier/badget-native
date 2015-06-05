//
//  MissingViewController.swift
//  Badget
//
//  Created by Toon Bertier on 03/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Pusher
import Alamofire

class MissingViewController: UIViewController, MissingViewDelegate {
    
    var theView:MissingView {
        get {
            return self.view as! MissingView
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.title = "Vermist"
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = MissingView(frame: CGRectMake(0, 44, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 93))
        self.theView.delegate = self
        setMissingInView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(FBSDKAccessToken.currentAccessToken() == nil) {
            self.parentViewController!.presentViewController(FBLoginViewController(viewToLoad: .MissingLoginView), animated: true, completion: nil)
        }
        
        // Do any additional setup after loading the view.
    }
    
    func setMissingInView() {
        var url = "http://student.howest.be/toon.bertier/20142015/MA4/BADGET/api/users/facebookids/" + FBSDKAccessToken.currentAccessToken().userID
        Alamofire.request(.GET, url).responseJSON { (request, response, data, error) in
            if let dataUnwrapped:AnyObject = data {
                if(data!["missing"] as! Int == 1) {
                    self.theView.missing = 1
                } else {
                    self.theView.missing = 0
                }
            }
        }
    }
    
    func updateMissingStatusUser() {
        
        if(FBSDKAccessToken.currentAccessToken() != nil) {
            
            var url = "http://student.howest.be/toon.bertier/20142015/MA4/BADGET/api/users/missing/" + FBSDKAccessToken.currentAccessToken().userID
            
            var missingParam:Int!
            
            if(self.theView.missing == 1) {
                missingParam = 0
            } else {
                missingParam = 1
            }
            
            Alamofire.request(.PUT, url, parameters: ["missing": missingParam]).response { (request, response, data, error) in
                if(response?.statusCode == 200) {
                    println("alert sended")
                    self.setMissingInView()
                }
                if((error) != nil) {
                    println(error?.description)
                }
            }

        } else {
            println("user isn't logged in with FB")
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
