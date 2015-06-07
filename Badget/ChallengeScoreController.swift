//
//  ChallengeScoreController.swift
//  Badget
//
//  Created by Toon Bertier on 06/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit
import Alamofire

class ChallengeScoreController: NSObject {
    
    class func handleScore(score:Double, challenge:ChallengeName) {
        println("about to send the score")
        
        var challengeId = 0
        
        switch challenge {
            case .StraightLine:
                challengeId = 1
            case .CrowdSurfing:
                challengeId = 2
            case .Quiz:
                challengeId = 3
        }
        
        ChallengeScoreController.sendScoreToDatabase(score, challengeId: challengeId)
    }
    
    class func calculateScoreStraightLine(score:Double) {
        if(score > 0.9) {
            println("goud")
        } else if (score > 0.75) {
            println("zilver")
        } else {
            println("brons")
        }
    }
    
    class func calculateScoreCrowdsurfing(score:Double) {
        if(score > 200) {
            println("goud")
        } else if (score > 100) {
            println("zilver")
        } else {
            println("brons")
        }
    }
    
    class func calculateScoreQuiz(score:Double) {
        if(score > 0.66) {
            println("goud")
        } else if (score > 0.33) {
            println("zilver")
        } else {
            println("brons")
        }
    }
    
    class func sendScoreToDatabase(score:Double, challengeId:Int) {
        
        var params = ["challenge_id": challengeId, "score": score, "device_id": UIDevice.currentDevice().identifierForVendor.UUIDString]  as [String : AnyObject]
        
        Alamofire.request(.POST, "http://student.howest.be/toon.bertier/20142015/MA4/BADGET/api/challenges/", parameters: params).response { (request, response, data, error) -> Void in
            println(response)
        }
    }
   
}
