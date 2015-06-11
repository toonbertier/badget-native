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
    var titleLabel:UILabel?
    var noBadgeTitle:UILabel?
    var noBadgeDescr:UILabel?
    weak var delegate:BadgeViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(UIImageView(image: UIImage(named: "white-bg")!))
        
        self.scrollView = UIScrollView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 410))
        self.scrollView.delegate = self
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBadgesArray(badges:Array<Badge>) {
        self.badges = badges
    }
    
    func renderBadges(afterChallenge:Bool) {
        removeNoBadgeLabels()
        if(self.badges.count > 1) {
            renderScrollingBadges()
        } else if(self.badges.count == 1) {
            renderAfterChallengeBadge()
            if(afterChallenge) {
                renderBackToOverviewButton()
            }
        } else {
            showNoBadgeLabels()
        }
    }
    
    func showNoBadgeLabels() {
        self.noBadgeTitle = BadgetUI.makeTitle("NOG GEEN BADGES")
        self.noBadgeTitle?.center = CGPointMake(self.center.x, self.center.y - 100)
        self.addSubview(self.noBadgeTitle!)
        
        self.noBadgeDescr = BadgetUI.makeDescription("Begin vlug aan de challenges en grijp die hoogste badges! Wanneer je de challenges tot een goed einde hebt gebracht, kun je aan onze stand enkele festivalgoodies afhalen!", width: 250, highlights: ["badges", "festivalgoodies afhalen"])
        self.noBadgeDescr?.center = CGPointMake(self.center.x, self.center.y)
        self.addSubview(self.noBadgeDescr!)
    }
    
    func removeNoBadgeLabels() {
        self.noBadgeDescr?.removeFromSuperview()
        self.noBadgeTitle?.removeFromSuperview()
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
            self.titleLabel!.removeFromSuperview()
        }
        
        self.titleLabel = BadgetUI.makeTitle(self.badges[index].title)
        self.titleLabel?.center = CGPointMake(self.center.x, self.center.y + 50)
        self.addSubview(self.titleLabel!)
        
        self.descriptionLabel = BadgetUI.makeDescription(self.badges[index].descr, width:250, highlights: [])
        self.descriptionLabel?.center = CGPointMake(self.center.x, self.center.y + 100)
        self.addSubview(self.descriptionLabel!)
        
    }
    
    func renderAfterChallengeBadge() {
        let level = self.badges[0].valueForKey("level") as! Int
        let challenge_id = self.badges[0].valueForKey("challengeId") as! Int
        
        let image = UIImage(named: "\(challenge_id.description)-\(level.description)")
        var imageView = UIImageView(image: image!)
        imageView.frame = CGRectMake(58, 40, image!.size.width, image!.size.height)
        
        self.addSubview(imageView)
        
        renderDescription(0)
    }
    
    func renderBackToOverviewButton() {
        let backToOverview = BadgetUI.makeButton("NAAR OVERZICHT", center: CGPointMake(self.center.x, self.center.y + 170), width: 200)
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
