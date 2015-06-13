//
//  NoConnectionView.swift
//  Badget
//
//  Created by Toon Bertier on 13/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

class NoConnectionView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        showIllustration()
        showText()
    }
 
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showIllustration() {
        let image = UIImage(named: "no-internet-bg")
        let imageView = UIImageView(image: image!)
        imageView.center = self.center
        self.addSubview(imageView)
    }
    
    func showText() {
        let titleLabel = BadgetUI.makeTitle("OEPS!")
        titleLabel.center = CGPointMake(self.center.x, self.center.y - 140)
        self.addSubview(titleLabel)
        
        let descrLabel = BadgetUI.makeDescription("Om deze functie te gebruiken is een internetverbinding vereist. Gelieve verbinding te maken met Wifi of 3G/4G.", width: 270, highlights: ["internetverbinding vereist"])
        descrLabel.center = CGPointMake(self.center.x, self.center.y - 90)
        self.addSubview(descrLabel)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
