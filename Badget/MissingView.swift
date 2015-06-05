//
//  MissingView.swift
//  Badget
//
//  Created by Toon Bertier on 04/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

protocol MissingViewDelegate:class {
    func updateMissingStatusUser()
}

class MissingView: UIView {
    
    weak var delegate:MissingViewDelegate?
    var missing:Int! {
        didSet {
            updateHelpButton()
        }
    }
    var helpButton:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.helpButton = UIButton(frame: CGRectMake(self.center.x - 50, self.center.y, 100, 44))
        self.helpButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.helpButton.backgroundColor = UIColor.redColor()
        self.helpButton.addTarget(self, action: "tappedHelp:", forControlEvents: .TouchUpInside)
        
        self.addSubview(self.helpButton)
    }
    
    func tappedHelp(sender:UIButton) {
        self.delegate?.updateMissingStatusUser()
    }
    
    func updateHelpButton() {
        if self.missing == 1 {
            self.helpButton.setTitle("Terecht", forState: .Normal)
        } else {
            self.helpButton.setTitle("Help!", forState: .Normal)
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
