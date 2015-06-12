//
//  CrowdSurfingViewController.swift
//  Badget
//
//  Created by Toon Bertier on 02/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

import UIKit
import CoreLocation
import MapKit
import CoreMotion
import AudioToolbox

class CrowdSurfingViewController: UIViewController, CrowdSurfinViewDelegate, BadgeViewDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var motionManager = CMMotionManager()
    var pointA:CLLocation?
    var totalDistance:CLLocationDistance?
    var locationLabel:UILabel!
    var step = 1
    var hasVibratedWhenLayingDown:Bool = false
    var theView:CrowdSurfingView {
        get {
            return self.view as! CrowdSurfingView
        }
    }
    
    override func loadView() {
        self.view = CrowdSurfingView(frame: CGRectMake(0, 44, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 93))
        self.theView.delegate = self
        self.theView.showExplanation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.delegate = self
        
        askForLocationServicePermission()
    }
    
    override func viewDidAppear(animated: Bool) {
        if motionManager.accelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.5
            checkPosition()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        motionManager.stopDeviceMotionUpdates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showBadge() {
        let badgeVC = BadgeViewController(challengeId: 2, afterChallenge: true)
        badgeVC.theView.delegate = self
        self.navigationController?.presentViewController(badgeVC, animated: true, completion: nil)
    }
    
    func backToOverview() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    //MOTION FUNCTIES
    
    func checkPosition() {
        
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler: {
            (data: CMAccelerometerData!, error: NSError!) in
            
            var xAcc = data.acceleration.x
            var yAcc = data.acceleration.y
            var zAcc = data.acceleration.z
            
            switch (self.step) {
                
            case 1:
                //check iphone tegen borst
                self.checkIfStraightUp(xAcc, y: yAcc, z: zAcc)
            case 2:
                //check user op zijn rug = start crowdsurfen
                self.checkIfLayingDown(xAcc, y: yAcc, z: zAcc)
            case 3:
                //check user blijft op zijn rug en afstand meten = bezig met crowdsurfen
                self.checkIfLayingDown(xAcc, y: yAcc, z: zAcc)
            case 4:
                //check user weer recht en stoppen met afstand en beweging meten
                self.backUp()
                
            default:
                ()
            }
            
        })
    }
    
    func checkIfStraightUp(x:Double, y:Double, z:Double) {
        
        if(x < 0.50 && x > -0.50 && y < -0.80 && z < 0.50 && z > -0.50) {
            println("straight")
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            if(self.step == 1) {
                self.step = 2
            }
            
            if(self.step == 4) {
                println("done")
            }
        }
    }
    
    func checkIfLayingDown(x:Double, y:Double, z:Double) {
        
        if(!self.hasVibratedWhenLayingDown) {
            if(x > -0.80 && x < 0.80 && y > -0.80 && y < 0.80 && z > 0.80) {
                println("down")
                self.step = 3
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.theView.removeExplanation()
                self.theView.showDistance()
                self.hasVibratedWhenLayingDown = true
           
                startUpdatingLocation()
                startGyroUpdates()
            }
        }
    }
    
    func backUp() {
        println("back up!")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        stopUpdatingLocation()
        self.motionManager.stopDeviceMotionUpdates()
        self.motionManager.stopAccelerometerUpdates()
        self.theView.showBadgeButton()
        if let totalDistanceUnwrapped = self.totalDistance {
            ChallengeScoreController.handleScore(self.totalDistance!, challenge: .CrowdSurfing)
        }
        println("updates stopped - all done")
    }
    
    func startGyroUpdates() {
        motionManager.deviceMotionUpdateInterval = 0.5
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
        var yaw = toDegrees(attitude.yaw)
        
        println(pitch)
        
        if(roll < -120 || roll < 90 || pitch < -60 || pitch > 60) {
            self.step = 4
        }
        
    }
    
    func toDegrees(radians:Double) -> Double {
        return 180 / M_PI * radians
    }
    

    
    //LOCATION FUNCTIES
    
    func askForLocationServicePermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Locatie tracken geweigerd", message: "Deze challenge kan niet voltooid worden zonder uw locatie te raadplegen", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Terug", style: .Cancel, handler: nil)
        
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func startUpdatingLocation() {
        self.locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch (CLLocationManager.authorizationStatus()) {
            
        case CLAuthorizationStatus.NotDetermined:
            println("not determined")
            askForLocationServicePermission()
            
        case CLAuthorizationStatus.Denied:
            println("denied")
            showAlert()
            
        case CLAuthorizationStatus.Restricted:
            println("restricted")
            showAlert()
            
        case CLAuthorizationStatus.AuthorizedWhenInUse:
            println("when in use")
            
        case CLAuthorizationStatus.AuthorizedAlways:
            println("always")
            
            
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        if let pointAUnwrapped = pointA {
            let pointB = locations.last as? CLLocation
            
            if let pointBUnwrapped = pointB {
                
                let d = pointBUnwrapped.distanceFromLocation(pointAUnwrapped)
                
                if let totalDistanceUnwrapped = self.totalDistance {
                    println(d)
                    if(d < 5) {
                        self.totalDistance! += d
                        self.theView.updateDistanceLabel(totalDistanceUnwrapped)
                    }
                } else {
                    self.totalDistance = 0
                    self.theView.updateDistanceLabel(self.totalDistance!)
                }
                
                pointA = pointBUnwrapped
            }
            
        } else {
            
            println("no point A")
            pointA = locations.last as? CLLocation
            
        }
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
