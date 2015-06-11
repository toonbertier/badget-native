//
//  ChallengeExplanationFactory.swift
//  Badget
//
//  Created by Toon Bertier on 11/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

class ChallengeExplanationFactory: NSObject {
    
    class func createArrayFromJSONData(data:NSData) -> Array<ChallengeExplanation> {
        
        let json = JSON(data: data)
        
        var itemArray = Array<ChallengeExplanation>()
        
        for (index: String, subJson: JSON) in json {
            
            let image = subJson["image"].stringValue
            let descr = subJson["descr"].stringValue
            let stap1 = subJson["stap1"].stringValue
            let stap2 = subJson["stap2"].stringValue
            let stap3 = subJson["stap3"].stringValue
            
            let explanation = ChallengeExplanation(image: image, descr: descr, stap1: stap1, stap2: stap2, stap3: stap3)
            
            itemArray.append(explanation)
            
        }
        
        return itemArray;
        
    }
   
}
