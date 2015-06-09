//
//  BadgeView.swift
//  Badget
//
//  Created by Toon Bertier on 07/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

protocol BadgeViewDelegate:class {
    func backToOverview()
}

class BadgeView: UIView, UIScrollViewDelegate {
    
    var scrollView:UIScrollView!
    var badges:Array<Badge>!
    var descriptionLabel:UILabel?
    weak var delegate:BadgeViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.scrollView = UIScrollView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 410))
        self.scrollView.delegate = self
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBadgesArray(badges:Array<Badge>) {
        self.badges = badges
    }
    
    func renderBadges() {
        if(self.badges.count > 1) {
            renderScrollingBadges()
        } else {
            renderAfterChallengeBadge()
        }
    }
    
    func renderScrollingBadges() {
        
        self.scrollView.subviews.map({ $0.removeFromSuperview() })
        
        self.scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(self.scrollView)
        var xPos = CGFloat(58)
        
        for(var i = 0; i < self.badges.count ; i++) {
            let level = self.badges[i].valueForKey("level") as! Int
            let challenge_id = self.badges[i].valueForKey("challengeId") as! Int
            
            let image = UIImage(named: "\(challenge_id.description)-\(level.description)")
            var imageView = UIImageView(image: image!)
            imageView.frame = CGRectMake(xPos, 40, image!.size.width, image!.size.height)
            
            self.scrollView.addSubview(imageView)
            xPos += CGFloat(image!.size.width + 30)
        }
        
        self.scrollView.contentSize = CGSizeMake(xPos + 30, 0)
        renderDescription(0)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var offset = self.scrollView.contentOffset
        println(offset)
        
        if(offset.x == 400) {
            renderDescription(2)
        } else if(offset.x > 235 && offset.x < 245) {
            renderDescription(1)
        } else if(offset.x > -5 && offset.x < 5) {
            renderDescription(0)
        }
    }
    
    func renderDescription(index:Int) {
        
        if let descrLabel = self.descriptionLabel {
            self.descriptionLabel!.removeFromSuperview()
        }
        
        let descrTxt = self.badges[index].descr as NSString
        println(descrTxt)
        
        let font = UIFont(name: "HelveticaNeue", size: 14)
        
        let boundingRect = descrTxt.boundingRectWithSize(CGSizeMake(self.frame.width - 60, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font!], context: nil)
        
        self.descriptionLabel = UILabel(frame: CGRectMake(50,300,boundingRect.size.width,boundingRect.size.height))
        self.descriptionLabel?.text = descrTxt as String
        self.descriptionLabel?.textAlignment = .Center
        self.descriptionLabel?.numberOfLines = 0
        self.descriptionLabel?.sizeToFit()
        self.addSubview(self.descriptionLabel!)
        
    }
    
    func renderAfterChallengeBadge() {
        let level = self.badges[0].valueForKey("level") as! Int
        let challenge_id = self.badges[0].valueForKey("challengeId") as! Int
        
        let image = UIImage(named: "\(challenge_id.description)-\(level.description)")
        var imageView = UIImageView(image: image!)
        imageView.frame = CGRectMake(58, 40, image!.size.width, image!.size.height)
        
        self.addSubview(imageView)
        
        renderButtons()
        renderDescription(0)
    }
    
    func renderButtons() {
        let backToOverview = UIButton(frame: CGRectMake(self.center.x - 100, self.frame.height, 200, 44))
        backToOverview.setTitle("naar overzicht", forState: .Normal)
        backToOverview.backgroundColor = .redColor()
        backToOverview.addTarget(self, action: "backToOverview:", forControlEvents: .TouchUpInside)
        
        self.addSubview(backToOverview)
    }
    
    func backToOverview(sender:UIButton) {
        self.delegate?.backToOverview()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}
