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
    
    var mapView:MKMapView!
    var mapPull:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.mapView = MKMapView(frame: CGRectMake(0, self.frame.height - 150, self.frame.width, self.frame.height))
        self.addSubview(self.mapView)
        self.bringSubviewToFront(self.mapView)
        
        var panRecognizer = UIPanGestureRecognizer(target: self, action: "panHandler:")
        
        self.mapPull = UIView(frame: CGRectMake(self.center.x-25, self.frame.height-160, 50, 20))
        self.mapPull.backgroundColor = .redColor()
        self.addSubview(self.mapPull)
        self.bringSubviewToFront(self.mapPull)
        
        UIView.setAnimationDuration(0)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        let touch = touches.first as! UITouch
        let location = touch.locationInView(self)
        
        UIView.beginAnimations("draggingMapPull", context: nil)
        self.mapPull.frame = CGRectMake(self.center.x - 25, location.y, 50, 20)
        self.mapView.frame = CGRectMake(0, location.y + 10, self.frame.width, self.frame.height)
        UIView.commitAnimations()
    
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
