//
//  ChallengeOverviewViewController.swift
//  Badget
//
//  Created by Toon Bertier on 02/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

enum ChallengeName:String {
    
    case StraightLine = "In rechte lijn"
    case CrowdSurfing = "Crowdsurfen"
    case Quiz = "Quiz"
    
}

class ChallengeOverviewViewController: UIViewController, ChallengeOverviewViewDelegate {
    
    var theView:ChallengeOverviewView {
        get {
            return self.view as! ChallengeOverviewView
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.title = "Challenges"
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = ChallengeOverviewView(frame: UIScreen.mainScreen().bounds)
        self.theView.delegate = self
    }
    
    func didChooseChallenge(name:ChallengeName) {
        self.navigationController?.pushViewController(ChallengeExplanationViewController(name: name), animated: true)
        
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
