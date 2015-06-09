//
//  BadgeFactory.swift
//  Badget
//
//  Created by Toon Bertier on 07/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

class BadgeFactory: NSObject {
    
    class func createArrayFromJSONData(data:NSData) -> Array<Badge> {
        
        let json = JSON(data: data)
        
        var itemArray = Array<Badge>()
        
        for (index: String, subJson: JSON) in json {
            
            let title = subJson["title"].stringValue
            let level = subJson["level"].intValue
            let descr = subJson["description"].stringValue
            let challengeId = subJson["challenge_id"].intValue
            let challengeName = subJson["challenge_name"].stringValue
            
            let badge = Badge(title: title, level: level, descr: descr, challengeId: challengeId, challengeName: challengeName)
            
            itemArray.append(badge)
            
        }
        
        return itemArray;
        
    }
   
}
