//
//  ChecklistCell.swift
//  Badget
//
//  Created by Toon Bertier on 31/05/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

class ChecklistCell: UITableViewCell {
    
    var checked = false
    var checkBox:UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        
        self.textLabel?.font = UIFont(name: "AvenirNext-Regular", size: 16)
        
        self.checkBox = UIButton(frame: CGRectMake(0, 0, 28, 28))
        self.checkBox.setBackgroundImage(UIImage(named: "unchecked"), forState: .Normal)
        self.checkBox.addTarget(self, action: "checkboxTapped", forControlEvents: .TouchUpInside)
        
        self.backgroundColor = UIColor.clearColor()
        
        self.accessoryView = self.checkBox
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkboxTapped() {
        self.checked = !self.checked
        
        if(self.checked) {
            self.checkBox.setBackgroundImage(UIImage(named: "checked"), forState: .Normal)
        } else {
            self.checkBox.setBackgroundImage(UIImage(named: "unchecked"), forState: .Normal)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
