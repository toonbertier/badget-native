//
//  QuestionFactory.swift
//  Badget
//
//  Created by Toon Bertier on 10/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

class QuestionFactory: NSObject {
    
    class func createFromJSONData( data:NSData ) -> Array<Question> {
        
        let json = JSON(data: data)
        
        var itemArray = Array<Question>()
        
        for (index: String, subJson: JSON) in json {
            
            let question = subJson["question"].stringValue
            let answer = subJson["answer"].boolValue
            let descr = subJson["descr"].stringValue
            
            let itemData = Question(question: question, answer: answer, descr: descr)
            
            itemArray.append(itemData)
            
        }
        
        return itemArray;
    }
   
}
