//
//  ChecklistFactory.swift
//  Badget
//
//  Created by Toon Bertier on 31/05/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

class ChecklistFactory: NSObject {
    
    class func createFromJSONData( data:NSData ) -> Array<ChecklistData> {
        
        let json = JSON(data: data)
        
        var itemArray = Array<ChecklistData>()
        
        for (index: String, subJson: JSON) in json {
            
            let title = subJson["title"].stringValue
            let checked = subJson["checked"].boolValue
            
            let itemData = ChecklistData(title: title, checked: checked)
            
            itemArray.append(itemData)
            
        }
        
        return itemArray;
    }
    
}
