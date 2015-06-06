//
//  MissingFriendCell.swift
//  Badget
//
//  Created by Toon Bertier on 05/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

class MissingFriendCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
}
