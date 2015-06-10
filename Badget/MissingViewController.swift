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
import CoreLocation

class MissingViewController: UIViewController, MissingViewDelegate, CLLocationManagerDelegate {
    
    var theView:MissingView {
        get {
            return self.view as! MissingView
        }
    }
    var locationManager:CLLocationManager!
    var location:CLLocation?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.title = "Vermist"
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = MissingView(frame: CGRectMake(0, 44, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 93))
        self.theView.delegate = self
        setMissingInView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(FBSDKAccessToken.currentAccessToken() == nil) {
            self.parentViewController!.presentViewController(FBLoginViewController(viewToLoad: .MissingLoginView), animated: true, completion: nil)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.theView.checkInternetConnection()
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.stopUpdatingLocation()
    }
    
    func setMissingInView() {
        if(FBSDKAccessToken.currentAccessToken() != nil) {
            var url = "http://student.howest.be/toon.bertier/20142015/MA4/BADGET/api/users/facebookids/" + FBSDKAccessToken.currentAccessToken().userID
            println(url)
            Alamofire.request(.GET, url).responseJSON { (request, response, data, error) in
                if let dataUnwrapped:AnyObject = data {
                    if(data!["missing"] as! Int == 1) {
                        self.theView.missing = 1
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "userIsMissing")
                    } else {
                        self.theView.missing = 0
                        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "userIsMissing")
                    }
                }
            }
        } else {
            self.theView.missing = 0
        }
    }
    
    func didUpdateMissingStatusUser() {
        
        if(FBSDKAccessToken.currentAccessToken() != nil) {
            uploadMissingStatusToDatabase()

        } else {
            println("user isn't logged in with FB")
        }
    
    }
    
    func uploadMissingStatusToDatabase() {
        var url = "http://student.howest.be/toon.bertier/20142015/MA4/BADGET/api/users/missing/" + FBSDKAccessToken.currentAccessToken().userID
        
        var params = getMissingParameters()
        
        Alamofire.request(.PUT, url, parameters: params).response { (request, response, data, error) in
            if(response?.statusCode == 200) {
                println("alert sended")
                self.setMissingInView()
                self.stopUpdatingLocation()
            }
            if((error) != nil) {
                println(error?.description)
            }
        }
    }
    
    func getMissingParameters() -> [String: AnyObject] {
        
        var missingParam:Int!
        
        if(self.theView.missing == 1) {
            missingParam = 0
        } else {
            missingParam = 1
        }
        
        var latitude:Double!
        var longitude:Double!
        
        if let locationUnwrapped = self.location {
            latitude = self.location!.coordinate.latitude as Double
            longitude = self.location!.coordinate.longitude as Double
        } else {
            latitude = 0
            longitude = 0
        }
        
        return ["missing": missingParam, "latitude": latitude, "longitude": longitude]
    }
    
    func didSelectFriendsList() {
        self.navigationController?.pushViewController(MissingFriendsOverviewViewController(), animated: true)
    }
    
    //LOCATION FUNCTIES
    
    func askForLocationServicePermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Locatie geweigerd", message: "Uw vrienden zullen uw locatie niet zien, ze krijgen wel nog altijd een bericht dat je ze kwijt bent", preferredStyle: .Alert)
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
            fallthrough
            
        case CLAuthorizationStatus.AuthorizedAlways:
            println("always")
            startUpdatingLocation()
            
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("location updated")
        self.location = locations.last as? CLLocation
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
