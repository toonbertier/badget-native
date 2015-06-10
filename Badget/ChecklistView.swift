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
    
    init(frame: CGRect, tableView:UITableView) {
        super.init(frame: frame)
        
        self.addSubview(UIImageView(image: UIImage(named: "white-bg")!))
        
        let title = BadgetUI.makeTitle("Ben je er klaar voor?")
        title.center = CGPointMake(self.center.x, 50)
        self.addSubview(title)
        
        tableView.frame = CGRectMake(20, 85, 280, 360)
        tableView.backgroundColor = UIColor.clearColor()
        self.addSubview(tableView)
        
        let exitButton = BadgetUI.makeButton("IK BEN KLAAR!", center: CGPointMake(self.center.x, self.center.y + 180), width: 140)
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
