//
//  ChecklistViewController.swift
//  Badget
//
//  Created by Toon Bertier on 30/05/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

class ChecklistViewController: UIViewController, TutorialContent, ChecklistDelegate {
    
    var pageIndex:Int!
    var tableVC:ChecklistTableViewController!
    var theView:ChecklistView {
        get{
            return self.view as! ChecklistView
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.tableVC = ChecklistTableViewController(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = ChecklistView(frame: UIScreen.mainScreen().bounds)
        self.theView.delegate = self
    }
    
    func exitTutorial() {
        self.view.window?.rootViewController = UITabBarController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableVC.tableView.frame = CGRectMake(0, 20, self.theView.frame.width, self.theView.frame.height - 150)
        self.theView.addSubview(self.tableVC.tableView)
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
