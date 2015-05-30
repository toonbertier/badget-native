//
//  IntroViewController.swift
//  Badget
//
//  Created by Toon Bertier on 30/05/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, TutorialContent {
    
    var pageIndex:Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.grayColor()
        
        let label = UILabel(frame: CGRectMake(view.center.x-50, view.center.y-200, 100, 44))
        label.text = "Intro-scherm"
        view.addSubview(label)
        
        // Do any additional setup after loading the view.
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
