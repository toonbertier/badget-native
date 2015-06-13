//
//  MissingFriendsOverviewView.swift
//  Badget
//
//  Created by Toon Bertier on 06/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit
import MapKit

class MissingFriendsOverviewView: UIView {
    
    var loadingView:UIView?
    var mapView:MKMapView!
    var tableView:UITableView!
    var mapPull:UIImageView!
    
    init(frame: CGRect, tableView:UITableView) {
        super.init(frame: frame)
        
        self.addSubview(UIImageView(image: UIImage(named: "white-bg")!))
        
        self.tableView = tableView
        self.tableView.frame = CGRectMake(0, 68, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height/2)
        self.tableView.backgroundColor = .clearColor()
        self.addSubview(self.tableView)
        
        self.mapView = MKMapView(frame: CGRectMake(0, self.center.x + 215, self.frame.width, self.frame.height))
        self.addSubview(self.mapView)
        self.bringSubviewToFront(self.mapView)
        
        self.mapPull = UIImageView(frame: CGRectMake(0, 0, 60, 30))
        self.mapPull.image = UIImage(named: "map-pull")!
        self.mapPull.center = CGPointMake(self.center.x, self.center.y + 70)
        self.mapPull.userInteractionEnabled = true
        self.addSubview(self.mapPull)
        self.bringSubviewToFront(self.mapPull)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showLoadingView() {
        self.loadingView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        self.loadingView?.backgroundColor = BadgetUI.getYellow(0.8)
        let loadingImg = UIImage(named: "loader")
        let imgView = UIImageView(image: loadingImg!)
        self.loadingView?.addSubview(imgView)
        self.addSubview(self.loadingView!)
    }
    
    func removeLoadingView() {
        self.loadingView?.removeFromSuperview()
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        let touch = touches.first as! UITouch
        let location = touch.locationInView(self)
        
        let mapPullCenter = self.mapPull.center
        if(location.x > mapPullCenter.x - 30 && location.x < mapPullCenter.x + 30 && location.y > mapPullCenter.y - 15 && location.y < mapPullCenter.y + 15) {
            UIView.beginAnimations("draggingMapPull", context: nil)
            UIView.setAnimationDuration(0)
            UIView.setAnimationDelay(0)
            UIView.setAnimationCurve(.Linear)
            self.mapPull.center = CGPointMake(self.center.x, location.y)
            self.mapView.frame = CGRectMake(0, location.y + 10, self.frame.width, self.frame.height)
            UIView.commitAnimations()
        }
    }
    
    func updateMap(location:CLLocationCoordinate2D) {
        
        if(location.latitude != 0 && location.longitude != 0) {
            let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let span = MKCoordinateSpanMake(0.0001, 0.0001)
            let region = MKCoordinateRegionMake(center, span)
            self.mapView.setRegion(region, animated: false)
            self.mapView.showsUserLocation = true
            
            let pin = PinData(coordinate: CLLocationCoordinate2DMake(location.latitude, location.longitude))
            self.mapView.addAnnotation(pin)
        }
        
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
