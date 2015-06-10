//
//  MissingView.swift
//  Badget
//
//  Created by Toon Bertier on 04/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

protocol MissingViewDelegate:class {
    func didUpdateMissingStatusUser()
    func didSelectFriendsList()
}

class MissingView: UIView {
    
    weak var delegate:MissingViewDelegate?
    var missing:Int! {
        didSet {
            updateHelpButton()
        }
    }
    var noConnection:Bool! {
        didSet {
            if(noConnection == true) {
                showOfflineAlert()
            }
        }
    }
    var helpButton:UIButton!
    var findFriends:UIButton!
    var offlineLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if(NSUserDefaults.standardUserDefaults().boolForKey("userIsMissing") == true) {
            self.missing = 1
        } else {
            self.missing = 0
        }
        
        showButtons()
        checkInternetConnection()
    }
    
    func checkInternetConnection() {
        //internet connectie checken
    }
    
    func showButtons() {
        
        self.helpButton = UIButton(frame: CGRectMake(self.center.x - 50, self.center.y - 100, 100, 44))
        self.helpButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.helpButton.backgroundColor = UIColor.redColor()
        self.helpButton.addTarget(self, action: "tappedHelp:", forControlEvents: .TouchUpInside)
        
        updateHelpButton()
        
        self.addSubview(self.helpButton)
        
        self.findFriends = UIButton(frame: CGRectMake(self.center.x - 100, self.center.y + 100, 200, 44))
        self.findFriends.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.findFriends.backgroundColor = UIColor.blueColor()
        self.findFriends.setTitle("Vind je vrienden", forState: .Normal)
        self.findFriends.addTarget(self, action: "tappedFindFriends:", forControlEvents: .TouchUpInside)
        
        self.addSubview(self.findFriends)
    }
    
    func showOfflineAlert() {
        
        let background = UIView(frame: CGRectMake(50, 100, self.frame.width - 100, self.frame.height - 200))
        background.backgroundColor = .grayColor()
        self.addSubview(background)
        
        self.offlineLabel = UILabel(frame: CGRectMake(self.center.x - 50, self.center.y, 100, 44))
        self.offlineLabel.text = "Deze functie kan offline niet gebruikt worden, gelieve u met het internet te verbinden."
        self.offlineLabel.textColor = .blackColor()
        self.addSubview(offlineLabel)
        
    }
    
    func tappedHelp(sender:UIButton) {
        self.delegate?.didUpdateMissingStatusUser()
    }
    
    func tappedFindFriends(sender:UIButton) {
        self.delegate?.didSelectFriendsList()
    }
    
    func updateHelpButton() {
        if self.missing == 1 {
            self.helpButton.setTitle("Terecht", forState: .Normal)
        } else {
            self.helpButton.setTitle("Help!", forState: .Normal)
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
