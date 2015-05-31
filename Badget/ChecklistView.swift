//
//  ChecklistView.swift
//  Badget
//
//  Created by Toon Bertier on 30/05/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

protocol ChecklistDelegate:class {
    func exitTutorial()
}

class ChecklistView: UIView {
    
    weak var delegate:ChecklistDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let exitButton = UIButton(frame: CGRectMake(self.center.x-100, self.frame.height - 100, 200, 44))
        exitButton.setTitle("All done", forState: .Normal)
        exitButton.backgroundColor = UIColor.grayColor()
        exitButton.addTarget(self, action: "exitTutorial", forControlEvents: .TouchUpInside)
        self.addSubview(exitButton)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func exitTutorial() {
        self.delegate?.exitTutorial()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
