//
//  MainTabBarController.swift
//  Badget
//
//  Created by Toon Bertier on 02/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //subscriben voor notificaties als vriend vermist is
        if(FBSDKAccessToken.currentAccessToken() != nil) {
            println("[MainTAB] - subscribing to friend events")
            FBLoginViewController.subscribeToFriendEvents()
        }
        
        //Challenges
        var challengeNavVC = UINavigationController(rootViewController: ChallengeOverviewViewController(nibName: nil, bundle: nil))
        
        //Vrienden kwijt
        var missingVC = MissingViewController(nibName: nil, bundle: nil)
        
        //Badges
        
        self.viewControllers = [challengeNavVC, missingVC]
        
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
