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
    
    func updateUserToMissing() {
        
        /*
        if(FBSDKAccessToken.currentAccessToken() != nil) {
            
            Alamofire.request(.POST, <#URLString: URLStringConvertible#>, parameters: <#[String : AnyObject]?#>, encoding: <#ParameterEncoding#>)
            
        }
        */
        
    }
    
    override func loadView() {
        self.view = MissingView(frame: CGRectMake(0, 44, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 93))
        self.theView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
