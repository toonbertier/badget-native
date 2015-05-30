//
//  TutorialContentController.swift
//  Badget
//
//  Created by Toon Bertier on 30/05/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

class TutorialContentController: UIViewController {

    var pageIndex: Int?
    var titleText : String!
    var imageName : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.redColor()
        
        var heading = UILabel(frame: CGRectMake(view.center.x - 50, view.center.y, 100, 44))
        heading.text = self.titleText
        heading.alpha = 0.1
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            heading.alpha = 1.0
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
