//
//  Question.swift
//  Badget
//
//  Created by Toon Bertier on 10/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

class Question: NSObject {
    
    var question:String
    var answer:Bool
    var descr:String
    
    init(question:String, answer:Bool, descr:String) {
        self.question = question
        self.answer = answer
        self.descr = descr
    }
    
}
