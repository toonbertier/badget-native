//
//  ChecklistData.swift
//  Badget
//
//  Created by Toon Bertier on 31/05/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

class ChecklistData: NSObject {
    
    let title:String
    let checked:Bool
    
    init(title:String, checked:Bool) {
        self.title = title
        self.checked = checked
    }
    
}
