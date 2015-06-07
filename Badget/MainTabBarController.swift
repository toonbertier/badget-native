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
        
        //fb login accesstoken hier pas beschikbaar -> check als user in database zit, anders nog eens proberen uploaden
        if(NSUserDefaults.standardUserDefaults().boolForKey("userIsInDatabase") == false) {
            if(FBSDKAccessToken.currentAccessToken() != nil) {
                FBLoginViewController.uploadUserToDatabase()
            } else {
                TutorialViewController.uploadUserToDatabaseWithoutFacebook()
            }
        }
        
        //subscriben voor notificaties als vriend vermist is
        if(FBSDKAccessToken.currentAccessToken() != nil) {
            println("[MainTAB] - subscribing to friend events")
            FBLoginViewController.doActionOnFacebookFriends(FBLoginViewController.subscribeToFriendEvents)
        }
        
        //Challenges
        var challengeNavVC = UINavigationController(rootViewController: ChallengeOverviewViewController(nibName: nil, bundle: nil))
        
        //Vrienden kwijt
        var missingNavVC = UINavigationController(rootViewController: MissingViewController(nibName: nil, bundle: nil))
        
        //Badges
        var badgesVC = BadgesOverviewViewController(nibName: nil, bundle: nil)
        
        self.viewControllers = [badgesVC, challengeNavVC, missingNavVC]
        
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
