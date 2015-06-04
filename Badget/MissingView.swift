//
//  MissingView.swift
//  Badget
//
//  Created by Toon Bertier on 04/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

protocol MissingViewDelegate:class {
    func updateUserToMissing()
}

class MissingView: UIView {
    
    weak var delegate:MissingViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let helpButton = UIButton(frame: CGRectMake(self.center.x - 50, self.center.y, 100, 44))
        helpButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        helpButton.backgroundColor = UIColor.redColor()
        helpButton.setTitle("HELP!", forState: .Normal)
        helpButton.addTarget(self, action: "tappedHelp:", forControlEvents: .TouchUpInside)
        
        self.addSubview(helpButton)
    }
    
    func tappedHelp(sender:UIButton) {
        self.delegate?.updateUserToMissing()
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
