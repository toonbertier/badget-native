//
//  ChecklistView.swift
//  Badget
//
//  Created by Toon Bertier on 30/05/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

class ChecklistView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /*
        let friendsButton = UIButton(frame: CGRectMake(self.center.x-100, self.center.y + 50, 200, 44))
        friendsButton.setTitle("Get my friends!", forState: .Normal)
        friendsButton.backgroundColor = UIColor.grayColor()
        friendsButton.addTarget(self, action: "getFriends", forControlEvents: .TouchUpInside)
        self.addSubview(friendsButton)
        */
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
