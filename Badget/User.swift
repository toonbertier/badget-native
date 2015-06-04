//
//  User.swift
//  Badget
//
//  Created by Toon Bertier on 04/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var deviceId:String
    var facebookId:String
    var name:String
    var missing:Bool
    
    init(deviceId:String, facebookId:String, name:String, missing:Bool) {
        self.deviceId = deviceId
        self.facebookId = facebookId
        self.name = name
        self.missing = missing
    }
    
}
