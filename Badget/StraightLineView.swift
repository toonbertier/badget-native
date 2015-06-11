//
//  StraightLineView.swift
//  Badget
//
//  Created by Toon Bertier on 02/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

protocol StraightLineViewDelegate:class {
    
    func stopGyroData()
    func stopTimer()
    func showBadge()
    
}

class StraightLineView: UIView {

    var rollValue = 0.0 {
        didSet {
            self.valuesUpdated()
        }
    }
    var pitchValue = 0.0 {
        didSet {
            self.valuesUpdated()
        }
    }
    var pointLabel:UILabel!
    var balanceCircle:CALayer!
    var bound:CALayer!
    var totalTime:Double = 0.0
    var points:Double = 0.0
    var stopButton:UIButton!
    weak var delegate:StraightLineViewDelegate?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.addSubview(UIImageView(image: UIImage(named: "white-bg")!))
        self.addSubview(UIImageView(image: UIImage(named: "stripes-bg")!))
        
        showBound()
        showBalanceCircle()
        showStopButton()
        showPoints()
        
    }
    
    func showBound() {
        self.bound = CALayer()
        let boundImage = UIImage(named: "balance-bound")!
        self.bound.contents = boundImage.CGImage
        self.bound.bounds = CGRectMake(0, 0, boundImage.size.width, boundImage.size.height)
        self.bound.position = self.center
        
        self.layer.addSublayer(bound)
    }
    
    func showBalanceCircle() {
        self.balanceCircle = CALayer()
        let circleImage = UIImage(named: "balance-circle")!
        self.balanceCircle.contents = circleImage.CGImage
        self.balanceCircle.bounds = CGRectMake(0, 0, circleImage.size.width, circleImage.size.height)
        self.balanceCircle.position = self.center
        
        self.layer.addSublayer(self.balanceCircle)
    }
    
    func showStopButton() {
        self.stopButton = BadgetUI.makeButton("STOP", center: CGPointMake(self.center.x, self.center.y + 180), width: 80)
        self.stopButton.addTarget(self, action: "stopButtonTouched:", forControlEvents: .TouchUpInside)
        self.addSubview(stopButton)
    }
    
    func showPoints() {
        self.pointLabel = UILabel(frame: CGRectMake(0, 0, 100, 44))
        self.pointLabel.center = CGPointMake(self.center.x, self.center.y - 60)
        self.pointLabel.textAlignment = .Center
        self.pointLabel.textColor = UIColor.blackColor()
        self.pointLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        self.addSubview(self.pointLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkCircle(sender:NSTimer) {
        
        self.totalTime++
        
        var x1 = self.balanceCircle.position.x
        var y1 = self.balanceCircle.position.y
        var x = self.bound.position.x
        var y = self.bound.position.y
        
        if((pow((x1 - x),2) + pow((y1 - y),2)) <= pow(75,2)) {
            self.points++
        }
        
        self.pointLabel.text = String(format:"%.0f", points) + "/" + String(format:"%.0f", totalTime)
        
    }
    
    func showBadgeButton() {
        self.stopButton.removeFromSuperview()
        self.stopButton = BadgetUI.makeButton("NAAR BADGE", center: CGPointMake(self.center.x, self.center.y + 180), width: 160)
        self.stopButton.addTarget(self, action: "showBadgeController:", forControlEvents: .TouchUpInside)
        self.addSubview(stopButton)
    }
    
    func showBadgeController(sender:UIButton) {
        self.delegate?.showBadge()
    }
    
    func valuesUpdated() {
        var frameWidthHalf = Double(self.frame.width/2)
        var frameHeightHalf = Double(self.frame.height/2)
        var rollPercentage = (self.rollValue/90)*100
        var pitchPercentage = (self.pitchValue/90)*100
        
        //maal 3 voor realistischere bounds
        var xPos = CGFloat(frameWidthHalf + frameWidthHalf/100*rollPercentage*3)
        var yPos = CGFloat(frameHeightHalf + frameHeightHalf/100*pitchPercentage*3)
        var newPosition = CGPointMake(xPos, yPos)
        
        self.balanceCircle.position = newPosition
    }
    
    func stopButtonTouched(sender:UIButton) {
        self.delegate?.stopGyroData()
        self.delegate?.stopTimer()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */


}
