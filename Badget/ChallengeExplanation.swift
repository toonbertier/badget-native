//
//  ChallengeExplanation.swift
//  Badget
//
//  Created by Toon Bertier on 11/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

class ChallengeExplanation: NSObject {
    
    var image:String
    var descr:String
    var stap1:String
    var stap2:String
    var stap3:String
    
    init(image:String, descr:String, stap1:String, stap2:String, stap3:String){
        self.image = image
        self.descr = descr
        self.stap1 = stap1
        self.stap2 = stap2
        self.stap3 = stap3
    }
   
}
