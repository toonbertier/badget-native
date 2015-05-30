//
//  TutorialViewController.swift
//  Badget
//
//  Created by Toon Bertier on 30/05/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    let pageTitles = ["Intro", "Facebook", "Checklist"]
    var count = 0
    
    var pageViewController:UIPageViewController!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageViewController = UIPageViewController()
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
        
        let pageContentViewController = self.viewControllerAtIndex(0)
        self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - 30)
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    
        var index = (viewController as! TutorialContentController).pageIndex!
        if(index >= self.pageTitles.count){
            return nil
        }
        index++
        return self.viewControllerAtIndex(index)
    
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    
        var index = (viewController as! TutorialContentController).pageIndex!
        if(index <= 0){
            return nil
        }
        index--
        return self.viewControllerAtIndex(index)
    
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        
        if((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
            return nil
        }
        
        let tutContController = TutorialContentController()
        tutContController.titleText = self.pageTitles[index]
        tutContController.pageIndex = index
        
        return tutContController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pageTitles.count
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
