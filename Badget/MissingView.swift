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
    var offlineView:UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(UIImageView(image: UIImage(named: "white-bg")!))
        
        if(NSUserDefaults.standardUserDefaults().boolForKey("userIsMissing") == true) {
            self.missing = 1
        } else {
            self.missing = 0
        }
        
        showButtons()
    }
    
    func checkInternetConnection() {
        if Reachability.isConnectedToNetwork() {
            removeOfflineAlert()
        } else {
            showOfflineAlert()
        }
    }
    
    func showButtons() {
        
        let helpImage = UIImage(named: "help-button")!
        self.helpButton = UIButton(frame: CGRectMake(0, 0, helpImage.size.width, helpImage.size.height))
        self.helpButton.center = CGPointMake(self.center.x, self.center.y - 80)
        self.helpButton.setBackgroundImage(helpImage, forState: .Normal)
        self.helpButton.addTarget(self, action: "tappedHelp:", forControlEvents: .TouchUpInside)
        updateHelpButton()
        self.addSubview(self.helpButton)
        
        let ofLabel = BadgetUI.makeTitle("OF")
        ofLabel.center = CGPointMake(self.center.x, self.center.y + 80)
        self.addSubview(ofLabel)
        
        self.findFriends = BadgetUI.makeButton("VIND JE VRIENDEN", center: CGPointMake(self.center.x, self.center.y + 160), width: 180)
        self.findFriends.addTarget(self, action: "tappedFindFriends:", forControlEvents: .TouchUpInside)
        self.addSubview(self.findFriends)
    }
    
    func showOfflineAlert() {
        self.offlineView = NoConnectionView(frame: CGRectMake(0, 0, 300, 500))
        self.offlineView!.center = self.center
        self.addSubview(self.offlineView!)
        self.bringSubviewToFront(self.offlineView!)
    }
    
    func removeOfflineAlert() {
        self.offlineView?.removeFromSuperview()
    }
    
    func tappedHelp(sender:UIButton) {
        self.delegate?.didUpdateMissingStatusUser()
    }
    
    func tappedFindFriends(sender:UIButton) {
        self.delegate?.didSelectFriendsList()
    }
    
    func updateHelpButton() {
        if self.missing == 1 {
            self.helpButton.setBackgroundImage(UIImage(named: "terecht-button")!, forState: .Normal)
        } else {
            self.helpButton.setBackgroundImage(UIImage(named: "help-button")!, forState: .Normal)
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
