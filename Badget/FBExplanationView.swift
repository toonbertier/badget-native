//
//  FBExplanationView.swift
//  Badget
//
//  Created by Toon Bertier on 10/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

class FBExplanationView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 0.93, green: 0.84, blue: 0.38, alpha: 0.95)
        
        showInfo()
        showButton()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showInfo() {
        
        let bgImage = UIImage(named: "fb-info-bg")
        let bg = UIImageView(frame: CGRectMake(self.center.x - bgImage!.size.width/2, self.center.y - bgImage!.size.height/2, bgImage!.size.width, bgImage!.size.height))
        bg.image = bgImage
        self.addSubview(bg)
        
        let title = UILabel(frame: CGRectMake(0, 0, bgImage!.size.width-20, 44))
        title.center = CGPointMake(self.center.x, self.center.y - 90)
        title.font = UIFont(name: "Dosis-SemiBold", size: 20)
        title.text = "Vind je vrienden terug!"
        title.textAlignment = .Center
        self.addSubview(title)
        
        let infoTxt = "Wij gebruiken uw Facebook enkel om uw vriendenlijst te raadplegen indien u of een van uw vrienden zoek raakt tijdens het festival. Wij posten in geen geval iets onder uw naam."
        let font2 = UIFont(name: "AvenirNext-Regular", size: 14)
        
        let boundingRect2 = infoTxt.boundingRectWithSize(CGSizeMake(bgImage!.size.width-20, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font2!], context: nil)
        
        let descrLabel = UILabel(frame: CGRectMake(self.center.x - boundingRect2.size.width/2 ,self.center.y - 62,boundingRect2.size.width,boundingRect2.size.height))
        descrLabel.text = infoTxt
        descrLabel.font = font2
        descrLabel.textAlignment = .Center
        descrLabel.numberOfLines = 0
        descrLabel.sizeToFit()
        self.addSubview(descrLabel)
        
    }
    
    func showButton() {
        
        let okButton = UIButton(frame: CGRectMake(60, 23, 120, 45))
        okButton.setBackgroundImage(UIImage(named: "button-bg")!, forState: .Normal)
        okButton.setTitle("Begrepen!", forState: .Normal)
        okButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        okButton.titleLabel!.font = UIFont(name: "Dosis-SemiBold", size: 16)
        okButton.center = CGPointMake(self.center.x, self.center.y + 80)
        okButton.addTarget(self, action: "okButtonTapped:", forControlEvents: .TouchUpInside)
        self.addSubview(okButton)
    }
    
    func okButtonTapped(sender:UIButton) {
        self.removeFromSuperview()
    }
}
