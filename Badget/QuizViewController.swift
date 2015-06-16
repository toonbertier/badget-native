//
//  QuizViewController.swift
//  Badget
//
//  Created by Toon Bertier on 02/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit
import CoreMotion

class QuizViewController: UIViewController, QuizViewDelegate, BadgeViewDelegate {

    let motionManager = CMMotionManager()
    var questions = Array<Question>()
    var points = 0
    var theView:QuizView {
        get {
            return self.view as! QuizView
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        loadQuestions()
        self.title = "Quiz"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadQuestions() {
        var path = NSBundle.mainBundle().URLForResource("quiz", withExtension: "json")
        var JsonData = NSData(contentsOfURL: path!)
        self.questions = QuestionFactory.createFromJSONData(JsonData!)
    }
    
    override func loadView() {
        self.view = QuizView(frame: CGRectMake(0, 44, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 93))
        self.theView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        let cards = getRandomCards()
        self.theView.removeExistingCards()
        self.theView.makeCards(cards)
    }
    
    override func viewDidAppear(animated: Bool) {
        if motionManager.accelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.05
            checkMovement()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        motionManager.stopAccelerometerUpdates()
    }
    
    func getRandomCards() -> Array<Question> {
        
        let randomIndexes = getRandomIndexes(self.questions, range: 3)
        
        var arr = Array<Question>()
        
        for randomIndex in randomIndexes {
            arr.append(self.questions[randomIndex])
        }
        
        return arr
    }
    
    func getRandomIndexes<T>(arr:Array<T>, range:Int) -> Set<Int> {
        
        var indexSet = Set<Int>()
        
        while(indexSet.count < 3) {
            let randomNumber = arc4random_uniform(UInt32(arr.count))
            indexSet.insert(Int(randomNumber))
        }
        
        return indexSet
    }
    
    func addOnePoint() {
        self.points++
        println(points)
    }
    
    func allCardsDone() {
        let score = Double(self.points/3)
        ChallengeScoreController.handleScore(score, challenge: .Quiz)
    }
    
    func showBadge() {
        let badgeVC = BadgeViewController(challengeId: 3, afterChallenge: true)
        badgeVC.theView.delegate = self
        self.navigationController?.presentViewController(badgeVC, animated: true, completion: nil)
    }
    
    func backToOverview() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func checkMovement() {
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler: {
            (data: CMAccelerometerData!, error: NSError!) in
            
            var x = data.acceleration.x
            var y = data.acceleration.y
            var z = data.acceleration.z
            
            println(z)
            
            if(x > 1.4 && x < 1.9) {
                println("throw right")
                self.theView.moveTopCard("right")
            } else if (x < -1.4 && x > -1.9) {
                println("throw left")
                self.theView.moveTopCard("left")
            }
            
        })
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
