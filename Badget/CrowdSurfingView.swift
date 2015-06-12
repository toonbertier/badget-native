//
//  CrowdSurfingView.swift
//  Badget
//
//  Created by Toon Bertier on 11/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

protocol CrowdSurfinViewDelegate:class {
    func showBadge()
}

class CrowdSurfingView: UIView {
    
    var phone:UIImageView!
    var distanceImage:UIImageView!
    var distanceLabel:UILabel!
    var titleLabel:UILabel!
    var descrLabel:UILabel!
    weak var delegate:CrowdSurfinViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(UIImageView(image: UIImage(named: "white-bg")!))
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showExplanation() {
        let image = UIImage(named: "phone")
        self.phone = UIImageView(image: image!)
        self.phone.center = CGPointMake(self.center.x, self.center.y - 90)
        self.addSubview(self.phone)
        
        self.titleLabel = BadgetUI.makeTitle("HOU JE IPHONE TEGEN JE BORST")
        self.titleLabel.center = CGPointMake(self.center.x, self.center.y + 70)
        self.addSubview(self.titleLabel)
        
        self.descrLabel = BadgetUI.makeDescription("Telkens wanneer je in de juiste positie zit, zal je iPhone trillen. Op het einde van de rit kan je je afgelegde afstand in meter zien.", width:250 ,highlights: [])
        self.descrLabel.center = CGPointMake(self.center.x, self.center.y + 160)
        self.addSubview(self.descrLabel)
    }
    
    func removeExplanation() {
        self.phone.removeFromSuperview()
        self.titleLabel.removeFromSuperview()
        self.descrLabel.removeFromSuperview()
    }
    
    func showDistance() {
        let image = UIImage(named: "distance")
        self.distanceImage = UIImageView(image: image!)
        self.distanceImage.center = CGPointMake(self.center.x, self.center.y)
        self.addSubview(self.distanceImage)
        
        self.distanceLabel = UILabel(frame: CGRectMake(0, 0, 100, 44))
        self.distanceLabel.font = UIFont(name: "Dosis-SemiBold", size: 40)
        self.distanceLabel.textAlignment = .Center
        self.distanceLabel.center = CGPointMake(self.center.x + 85, self.center.y + 40)
        self.addSubview(self.distanceLabel)
    }
    
    func updateDistanceLabel(distance:Double) {
        println("test")
        self.distanceLabel.text = String(format:"%.0f", distance)
    }
    
    func showBadgeButton() {
        let stopButton = BadgetUI.makeButton("NAAR BADGE", center: CGPointMake(self.center.x, self.center.y + 180), width: 160)
        stopButton.addTarget(self, action: "showBadgeController:", forControlEvents: .TouchUpInside)
        self.addSubview(stopButton)
    }
    
    func showBadgeController(sender:UIButton) {
        self.delegate?.showBadge()
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
