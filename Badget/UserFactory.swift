//
//  UserFactory.swift
//  Badget
//
//  Created by Toon Bertier on 04/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

class UserFactory: NSObject {
    
    class func createFromJSONData( data:NSData ) -> Array<User> {
        
        let json = JSON(data: data)
        
        var itemArray = Array<User>()
        
        for (index: String, subJson: JSON) in json {
            
            let deviceId = subJson["deviceId"].stringValue
            let facebookId = subJson["facebookId"].stringValue
            let name = subJson["name"].stringValue
            let missing = subJson["missing"].boolValue
            
            let itemData = User(deviceId: deviceId, facebookId: facebookId, name: name, missing: missing)
            
            itemArray.append(itemData)
            
        }
        
        return itemArray;
    }

   
}
