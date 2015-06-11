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
        
        let title = BadgetUI.makeTitle("Vind je vrienden terug!")
        title.center = CGPointMake(self.center.x, self.center.y - 90)
        self.addSubview(title)
        
        let descrLabel = BadgetUI.makeDescription("Wij gebruiken uw Facebook enkel om uw vriendenlijst te raadplegen indien u of een van uw vrienden zoek raakt tijdens het festival. Wij posten in geen geval iets onder uw naam.", width:250, highlights: [])
        descrLabel.center = CGPointMake(self.center.x, self.center.y - 15)
        self.addSubview(descrLabel)
        
    }
    
    func showButton() {
        
        let okButton = BadgetUI.makeButton("BEGREPEN", center: CGPointMake(self.center.x, self.center.y + 80), width: 120)
        okButton.addTarget(self, action: "okButtonTapped:", forControlEvents: .TouchUpInside)
        self.addSubview(okButton)
    }
    
    func okButtonTapped(sender:UIButton) {
        self.removeFromSuperview()
    }
}
