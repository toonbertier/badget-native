//
//  QuizView.swift
//  Badget
//
//  Created by Toon Bertier on 09/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

protocol QuizViewDelegate:class {
    func addOnePoint()
    func allCardsDone()
    func showBadge()
}

class QuizView: UIView {
    
    var cards = Array<QuestionCardView>()
    var count = 2 {
        didSet {
            if(count < 0) {
                self.delegate?.allCardsDone()
                showBadgeButton()
            }
        }
    }
    weak var delegate:QuizViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(UIImageView(image: UIImage(named: "white-bg")!))
        
        showButtons()
        showAnimation()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showButtons() {
        makeQuizButton(UIImage(named: "arrow-no")!, tag: 1, center: CGPointMake(50, self.center.y + 200))
        makeQuizButton(UIImage(named: "arrow-yes")!, tag: 2, center: CGPointMake(self.frame.width - 50, self.center.y + 200))
    }
    
    func makeQuizButton(image:UIImage!, tag:Int, center:CGPoint) {
        let button = UIButton(frame: CGRectMake(0, 0, 80, 60))
        button.setBackgroundImage(image, forState: .Normal)
        button.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
        button.center = center
        button.tag = tag
        self.addSubview(button)
    }
    
    func buttonTapped(sender:UIButton) {
        switch sender.tag {
            case 1: moveTopCard("left")
            case 2: moveTopCard("right")
            default:()
        }
    }
    
    func showAnimation() {
        let image = UIImage(named: "quiz-illustration")
        let imageView = UIImageView(image: image!)
        imageView.center = CGPointMake(self.center.x, self.center.y + 310)
        self.addSubview(imageView)
        
        let duration = 5.0
        let delay = 0.0
        let options = UIViewKeyframeAnimationOptions.CalculationModeLinear
        let rotation = CGFloat(M_PI/5)
        
        UIView.animateKeyframesWithDuration(duration, delay: delay, options: options, animations: {
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1/5, animations: {
                imageView.center = CGPointMake(self.center.x, self.center.y + 190)
            })
            UIView.addKeyframeWithRelativeStartTime(1/5, relativeDuration: 1/5, animations: {
                UIView.setAnimationCurve(UIViewAnimationCurve.EaseIn)
                imageView.transform = CGAffineTransformMakeRotation(rotation)
            })
            UIView.addKeyframeWithRelativeStartTime(2/5, relativeDuration: 1/5, animations: {
                UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
                imageView.transform = CGAffineTransformMakeRotation(-rotation)
            })
            UIView.addKeyframeWithRelativeStartTime(3/5, relativeDuration: 1/5, animations: {
                imageView.transform = CGAffineTransformMakeRotation(0)
            })
            UIView.addKeyframeWithRelativeStartTime(4/5, relativeDuration: 1/5, animations: {
                imageView.center = CGPointMake(self.center.x, self.center.y + 320)
            })
            
            }, completion: nil)
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
            let card = QuestionCardView(frame: CGRectMake(0, 0, 200, 120), data: data)
            card.center = CGPointMake(self.center.x, self.center.y - 50)
            cards.append(card)
            self.addSubview(card)
        }
    }
    
    func moveTopCard(direction:String) {
        
        if(count >= 0) {
            UIView.beginAnimations("throwingCard", context: nil)
            UIView.setAnimationDuration(0.5)
            UIView.setAnimationCurve(.EaseOut)
            var answer:Bool!
            
            switch direction {
            case "right":
                println("moving card right")
                cards[count].center = CGPointMake(self.frame.width + 200, self.cards[count].center.y)
                answer = true
            case "left":
                println("moving card left")
                cards[count].center = CGPointMake(-self.frame.width - 200, self.cards[count].center.y)
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
    
    func showBadgeButton() {
        let stopButton = BadgetUI.makeButton("NAAR BADGE", center: CGPointMake(self.center.x, self.center.y - 20), width: 160)
        stopButton.addTarget(self, action: "showBadgeController:", forControlEvents: .TouchUpInside)
        self.addSubview(stopButton)
    }
    
    func showBadgeController(sender:UIButton) {
        self.delegate?.showBadge()
    }
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
