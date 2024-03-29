//
//  StraightLineViewController.swift
//  Badget
//
//  Created by Toon Bertier on 02/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit
import CoreMotion

class StraightLineViewController: UIViewController, StraightLineViewDelegate, BadgeViewDelegate {

    let motionManager = CMMotionManager()
    var timer:NSTimer!
    var points:Double?
    var totalTime:Double?
    
    var theView:StraightLineView {
        get{
            return self.view as! StraightLineView
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "In rechte lijn"
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = StraightLineView(frame: CGRectMake(0, 44, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 93))
        self.theView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if motionManager.deviceMotionAvailable {
            startMotionUpdates()
        }
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self.theView, selector: "checkCircle:", userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
    }
    
    func showBadge() {
        let badgeVC = BadgeViewController(challengeId: 1, afterChallenge: true)
        badgeVC.theView.delegate = self
        self.navigationController?.presentViewController(badgeVC, animated: true, completion: nil)
    }
    
    func stopTimer() {
        self.timer.invalidate()
        
        self.points = self.theView.points
        self.totalTime = self.theView.totalTime
        
        var score:Double = 0
        
        if(self.totalTime > 0) {
            score = self.points!/self.totalTime!
        }
        
        ChallengeScoreController.handleScore(score, challenge: .StraightLine)
        self.theView.showBadgeButton()
        
    }
    
    func stopGyroData() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    func backToOverview() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func startMotionUpdates() {
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdatesToQueue(
            NSOperationQueue.currentQueue(), withHandler: {
                (deviceMotion, error) -> Void in
                
                if(error == nil) {
                    self.handleDeviceMotionUpdate(deviceMotion)
                } else {
                    println(error)
                }
        })
    }
    
    func handleDeviceMotionUpdate(deviceMotion:CMDeviceMotion) {
        var attitude = deviceMotion.attitude
        var roll = toDegrees(attitude.roll)
        var pitch = toDegrees(attitude.pitch)
        
        self.theView.rollValue = roll
        self.theView.pitchValue = pitch
        
    }
    
    func toDegrees(radians:Double) -> Double {
        return 180 / M_PI * radians
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
