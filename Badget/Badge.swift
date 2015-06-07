//
//  Badge.swift
//  Badget
//
//  Created by Toon Bertier on 07/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

class Badge: NSObject {
 
    var title:String
    var level:Int
    var descr:String
    var challengeId:Int
    var challengeName:String
    
    override var description:String {
        get {
            return "\(title)"
        }
    }
    
    init(title:String, level:Int, descr:String, challengeId:Int, challengeName:String){
        self.title = title
        self.level = level
        self.descr = descr
        self.challengeId = challengeId
        self.challengeName = challengeName
    }
    
}
