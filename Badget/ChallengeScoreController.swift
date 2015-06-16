//
//  ChallengeScoreController.swift
//  Badget
//
//  Created by Toon Bertier on 06/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class ChallengeScoreController: NSObject {
    
    class func handleScore(score:Double, challenge:ChallengeName) {
        
        var challengeId = 0
        
        switch challenge {
            case .StraightLine:
                challengeId = 1
            case .CrowdSurfing:
                challengeId = 2
            case .Quiz:
                challengeId = 3
        }
        
        ChallengeScoreController.saveScoreToCoreData(score, challengeId: challengeId)
        ChallengeScoreController.sendScoreToDatabase(score, challengeId: challengeId)
    }
    
    class func debugChallenges() {
        ChallengeScoreController.handleScore(0.78, challenge: ChallengeName.StraightLine)
        ChallengeScoreController.handleScore(78, challenge: ChallengeName.CrowdSurfing)
        ChallengeScoreController.handleScore(0.66, challenge: ChallengeName.Quiz)
    }
    
    class func getBadgesForChallenges(badges:Array<Badge>, challenges:Array<NSManagedObject>) -> (Array<Badge>) {
        
        var array = [Badge]()
        
        for challenge in challenges {
            
            let id:Int32 = challenge.valueForKey("challenge_id")!.intValue
            let score:Double = challenge.valueForKey("score")!.doubleValue
            
            switch id {
                case 1:
                    let level = getBadgeForStraightLine(score)
                    array.append(badges[level - 1])
                case 2:
                    let level = getBadgeForCrowdsurfing(score)
                    array.append(badges[level + 2])
                case 3:
                    let level = getBadgeForQuiz(score)
                    array.append(badges[level + 5])
                default:
                    println("do nothing")
            }
        }
        
        return array
    }
    
    class func getBadgeForStraightLine(score:Double) -> (Int) {
        if(score > 0.9) {
            return (3)
        } else if (score > 0.75) {
            return (2)
        } else {
            return (1)
        }
    }
    
    class func getBadgeForCrowdsurfing(score:Double) -> (Int) {
        if(score > 100) {
            return (3)
        } else if (score > 50) {
            return (2)
        } else {
            return (1)
        }
    }
    
    class func getBadgeForQuiz(score:Double) -> (Int) {
        if(score > 0.66) {
            return (3)
        } else if (score > 0.33) {
            return (2)
        } else {
            return (1)
        }
    }
    
    class func saveScoreToCoreData(score:Double, challengeId:Int) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let challenge = ChallengeScoreController.fetchExistingChallenge(challengeId)
        
        if(challenge.count > 0) {
            
            println("challenge already in core data")
            challenge[0].setValue(score, forKey: "score")
            
        } else {
            
            let entity = NSEntityDescription.entityForName("Challenge", inManagedObjectContext: context!)
            let newChallenge = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context!)
            newChallenge.setValue(score, forKey: "score")
            newChallenge.setValue(challengeId, forKey: "challenge_id")
        }
        
        var error: NSError?
        
        if !context!.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        } else {
            println("Saved successfully")
        }
    }
    
    class func fetchAllChallenges() -> [NSManagedObject] {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest(entityName: "Challenge")
        let sortIdAscending = NSSortDescriptor(key: "challenge_id", ascending: true)
        fetchRequest.sortDescriptors = [sortIdAscending]
        
        var error:NSError?
        
        let challenges = appDelegate.managedObjectContext?.executeFetchRequest(fetchRequest, error: &error) as! [NSManagedObject]
        return challenges
        
    }
    
    class func fetchExistingChallenge(challengeId:Int) -> [NSManagedObject] {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest(entityName: "Challenge")
        let predicate = NSPredicate(format: "challenge_id = %@", String(challengeId))
        fetchRequest.predicate = predicate
        
        var error:NSError?
        let challenges = appDelegate.managedObjectContext?.executeFetchRequest(fetchRequest, error: &error) as! [NSManagedObject]
        return challenges
    }
    
    class func sendScoreToDatabase(score:Double, challengeId:Int) {
        
        var params = ["challenge_id": challengeId, "score": score, "device_id": UIDevice.currentDevice().identifierForVendor.UUIDString]  as [String : AnyObject]
        
        Alamofire.request(.POST, "http://student.howest.be/toon.bertier/20142015/MA4/BADGET/api/challenges/", parameters: params).response { (request, response, data, error) -> Void in
            if(response?.statusCode == 200) {
                println("saved to database")
            }
        }
    }
   
}
