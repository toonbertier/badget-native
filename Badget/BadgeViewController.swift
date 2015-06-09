//
//  BadgesOverviewViewController.swift
//  Badget
//
//  Created by Toon Bertier on 05/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit
import CoreData

class BadgeViewController: UIViewController {
    
    var challengeId:Int?
    var badgesArray:Array<Badge>! {
        didSet {
            for badge in badgesArray {
                println(badge.description)
            }
        }
    }
    var theView:BadgeView {
        get {
            return self.view as! BadgeView
        }
    }
    
    init(challengeId:Int?) {
        super.init(nibName: nil, bundle: nil)
        self.title = "Badges"
        
        if let challengeIdUnwrapped = challengeId {
             self.challengeId = challengeIdUnwrapped
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = BadgeView(frame: CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 112))
    }
    
    override func viewWillAppear(animated: Bool) {
        getBadges()
        self.theView.setBadgesArray(self.badgesArray)
        self.theView.renderBadges()
    }
    
    func getBadges() {
        var path = NSBundle.mainBundle().URLForResource("badges", withExtension: "json")
        var jsonData = NSData(contentsOfURL: path!)
        
        let tmpArr = BadgeFactory.createArrayFromJSONData(jsonData!)
        if let challengeIdUnwrapped = self.challengeId {
            self.badgesArray = ChallengeScoreController.getBadgesForChallenges(tmpArr, challenges: ChallengeScoreController.fetchExistingChallenge(self.challengeId!))
        } else {
            self.badgesArray = ChallengeScoreController.getBadgesForChallenges(tmpArr, challenges: ChallengeScoreController.fetchAllChallenges())
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
