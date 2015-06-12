//
//  QuizView.swift
//  Badget
//
//  Created by Toon Bertier on 09/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

protocol QuestionCardViewDelegate:class {
    func addOnePoint()
    func allCardsDone()
}

class QuizView: UIView {
    
    var cards = Array<QuestionCardView>()
    var count = 2 {
        didSet {
            if(count < 0) {
                self.delegate?.allCardsDone()
            }
        }
    }
    weak var delegate:QuestionCardViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(UIImageView(image: UIImage(named: "white-bg")!))
        UIView.setAnimationDuration(2)
        UIView.setAnimationCurve(.EaseIn)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func removeExistingCards() {
        if(cards.count > 0) {
            for card in cards {
                card.removeFromSuperview()
            }
            self.cards = Array<QuestionCardView>()
            self.count = 2
        }
    }
    
    func makeCards(arr:Array<Question>) {
        for(var i = 0; i < arr.count; i++) {
            let data = arr[i]
            let card = QuestionCardView(frame: CGRectMake(0, 0, 140, 90), data: data)
            card.center = CGPointMake(self.center.x, self.center.y)
            cards.append(card)
            self.addSubview(card)
        }
    }
    
    func moveTopCard(direction:String) {
        
        if(count >= 0) {
            UIView.beginAnimations("throwingCard", context: nil)
            var answer:Bool!
            
            switch direction {
            case "right":
                println("moving card right")
                cards[count].center = CGPointMake(self.frame.width + 200, self.center.y)
                answer = true
            case "left":
                println("moving card left")
                cards[count].center = CGPointMake(-self.frame.width - 200, self.center.y)
                answer = false
            default:
                ()
            }
            
            UIView.commitAnimations()
            
            if(answer == cards[count].answer) {
                self.delegate?.addOnePoint()
            }
            
            cards.removeLast()
            count--
        }
    }
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
