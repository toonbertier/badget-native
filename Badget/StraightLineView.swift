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
    var bol:CAShapeLayer!
    var bound:CAShapeLayer!
    var totalTime:Double = 0.0
    var points:Double = 0.0
    var stopButton:UIButton!
    weak var delegate:StraightLineViewDelegate?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        var boundaryRect = CAShapeLayer()
        boundaryRect.fillColor = UIColor.grayColor().CGColor
        boundaryRect.path = UIBezierPath(rect: CGRectMake(frame.width/8, frame.height/4, frame.width/8*6, frame.height/8*6)).CGPath
        
        self.layer.addSublayer(boundaryRect)
        
        self.bound = CAShapeLayer()
        self.bound.lineWidth = 1
        self.bound.fillColor = nil
        self.bound.strokeColor = UIColor.blackColor().CGColor
        self.bound.position = self.center
        self.bound.path = UIBezierPath(ovalInRect: CGRectMake(-75, -75, 150, 150)).CGPath
        
        self.layer.addSublayer(bound)
        
        self.bol = CAShapeLayer()
        self.bol.fillColor = UIColor.redColor().CGColor
        self.bol.position = self.center
        self.bol.path = UIBezierPath(ovalInRect: CGRectMake(-25, -25, 50, 50)).CGPath
        
        self.layer.addSublayer(self.bol)
        
        self.stopButton = UIButton(frame: CGRectMake(self.center.x-50, frame.height, 100, 44))
        self.stopButton.setTitle("Klaar!", forState: .Normal)
        self.stopButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.stopButton.addTarget(self, action: "stopButtonTouched:", forControlEvents: .TouchUpInside)
        
        self.addSubview(stopButton)
        
        self.pointLabel = UILabel(frame: CGRectMake(40, 80, 100, 44))
        self.pointLabel.textColor = UIColor.blackColor()
        self.addSubview(self.pointLabel)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkCircle(sender:NSTimer) {
        
        self.totalTime++
        
        var x1 = self.bol.position.x
        var y1 = self.bol.position.y
        var x = self.bound.position.x
        var y = self.bound.position.y
        
        if((pow((x1 - x),2) + pow((y1 - y),2)) <= pow(75,2)) {
            self.points++
        }
        
        self.pointLabel.text = String(format:"%.0f", points) + "/" + String(format:"%.0f", totalTime)
        
    }
    
    func showBadgeButton() {
        
        self.stopButton.setTitle("Naar badge", forState: .Normal)
        self.stopButton.removeTarget(self, action: "stopButtonTouched:", forControlEvents: .TouchUpInside)
        self.stopButton.addTarget(self, action: "showBadgeController:", forControlEvents: .TouchUpInside)
        
    }
    
    func showBadgeController(sender:UIButton) {
        //statische functie om badgecontroller te tonen
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
        
        self.bol.position = newPosition
        checkBoundaryHits()
    }
    
    func stopButtonTouched(sender:UIButton) {
        self.bound.strokeStart = CGFloat(0.0)
        self.bound.strokeEnd = CGFloat(Double(self.points)/Double(self.totalTime))
        
        self.delegate?.stopGyroData()
        self.delegate?.stopTimer()
    }
    
    func checkBoundaryHits() {
        
        if(self.bol.position.x < frame.width/8
            || self.bol.position.x > frame.width - frame.width/8
            || self.bol.position.y < frame.height/4
            || self.bol.position.y > frame.height - frame.height/4) {
                
                self.delegate?.stopGyroData()
                self.delegate?.stopTimer()
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
