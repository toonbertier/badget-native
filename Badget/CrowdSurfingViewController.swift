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

class CrowdSurfingViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var motionManager = CMMotionManager()
    var mapView:MKMapView!
    var pointA:CLLocation?
    var totalDistance:CLLocationDistance?
    var locationLabel:UILabel!
    var step = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = CGRectMake(0, 44, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 93)
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.delegate = self
        
        self.locationLabel = UILabel(frame: CGRectMake(self.view.center.x-150, self.view.frame.height, 300, 44))
        self.locationLabel.textAlignment = .Center
        self.locationLabel.text = "Yet to calculate distance"
        self.view.addSubview(self.locationLabel)
        
        self.mapView = MKMapView(frame: CGRectMake(0, 44, self.view.frame.width, self.view.frame.height-60))
        self.view.addSubview(self.mapView)
        
        askForLocationServicePermission()
        
        if motionManager.accelerometerAvailable {
            
            motionManager.accelerometerUpdateInterval = 0.5
            checkPosition()
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                self.checkIfStraightUp(xAcc, y: yAcc, z: zAcc)
                
            default:
                println("do nothing")
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
                self.motionManager.stopAccelerometerUpdates()
                println("updates stopped - all done")
            }
        }
    }
    
    func checkIfLayingDown(x:Double, y:Double, z:Double) {
        
        if(x > -0.60 && x < 0.60 && y > -0.60 && y < 0.60 && z > 0.70) {
            println("down")
            self.step = 3
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            startUpdatingLocation()
            
        } else{
            if(self.step == 3) {
                println("back up!")
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                stopUpdatingLocation()
                self.step = 4
            }
        }
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
    
    func setRegion(point:CLLocation) {
        
        let center = CLLocationCoordinate2D(latitude: point.coordinate.latitude, longitude: point.coordinate.longitude)
        let span = MKCoordinateSpanMake(0.0001, 0.0001)
        let region = MKCoordinateRegionMake(center, span)
        self.mapView.setRegion(region, animated: false)
        self.mapView.showsUserLocation = true
        
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
            
            let pointB = locations.last as! CLLocation
            let d = pointB.distanceFromLocation(pointAUnwrapped)
            println(d)
            
            if let totalDistanceUnwrapped = self.totalDistance {
                self.totalDistance! += d
                self.locationLabel.text = "D: " + self.totalDistance!.description
            }
            
            setRegion(pointB)
            
            pointA = pointB
            
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
