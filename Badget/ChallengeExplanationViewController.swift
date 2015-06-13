//
//  ChallengeExplanationViewController.swift
//  Badget
//
//  Created by Toon Bertier on 02/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

class ChallengeExplanationViewController: UIViewController, ChallengeExplanationViewDelegate {
    
    var challengeName:ChallengeName = .StraightLine
    var explanations:Array<ChallengeExplanation>!
    
    var theView:ChallengeExplanationView {
        get {
            return self.view as! ChallengeExplanationView
        }
    }
    
    init(name:ChallengeName) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.challengeName = name
        self.title = "Uitleg"
        let backItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        loadExplanations()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadExplanations() {
        var path = NSBundle.mainBundle().URLForResource("explanations", withExtension: "json")
        var jsonData = NSData(contentsOfURL: path!)
        
        self.explanations = ChallengeExplanationFactory.createArrayFromJSONData(jsonData!)
    }
    
    func didStartChallenge() {
        
        var challengeVC:UIViewController!
        
        switch (self.challengeName) {
            
            case .StraightLine:
                challengeVC = StraightLineViewController()
            
            case .CrowdSurfing:
                challengeVC = CrowdSurfingViewController()
            
            case .Quiz:
                challengeVC = QuizViewController()
            
        }
        
        self.navigationController?.pushViewController(challengeVC, animated: true)
        
    }
    
    override func loadView() {
        switch (self.challengeName) {
            
        case .StraightLine:
            self.view = ChallengeExplanationView(frame: UIScreen.mainScreen().bounds, data: self.explanations[0])
            
        case .CrowdSurfing:
            self.view = ChallengeExplanationView(frame: UIScreen.mainScreen().bounds, data: self.explanations[1])
            
        case .Quiz:
            self.view = ChallengeExplanationView(frame: UIScreen.mainScreen().bounds, data: self.explanations[2])
            
        }
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
