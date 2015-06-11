//
//  MissingFriendsOverviewViewController.swift
//  Badget
//
//  Created by Toon Bertier on 06/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit
import MapKit

class MissingFriendsOverviewViewController: UIViewController, MissingFriendsOverviewTableViewControllerDelegate, MKMapViewDelegate {
    
    var tableVC:MissingFriendsOverviewTableViewController!
    var theView:MissingFriendsOverviewView {
        get {
            return self.view as! MissingFriendsOverviewView
        }
    }
    
    override func loadView() {
        self.tableVC = MissingFriendsOverviewTableViewController(nibName: nil, bundle: nil)
        self.tableVC.delegate = self
        self.view = MissingFriendsOverviewView(frame: CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 112), tableView: self.tableVC.tableView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.theView.mapView.delegate = self
    }
    
    func didSelectMissingFriend(data: User) {
        
        if(data.latitude != 0) {
            self.theView.updateMap(CLLocationCoordinate2DMake(data.latitude, data.longitude))
        }
        
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        var pinView = self.theView.mapView.dequeueReusableAnnotationViewWithIdentifier("pin")
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pinView.image = UIImage(named: "help-map")
        }
        
        return pinView
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
