//
//  TutorialViewController.swift
//  Badget
//
//  Created by Toon Bertier on 30/05/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

//DELEGATE PROTOCOL
protocol TutorialViewDelegate:class {
    func exitTutorial()
}

//TUTORIAL CONTENT PROTOCOL
protocol TutorialContent:class {
    var pageIndex:Int! {get}
}

class TutorialViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    let pages = ["intro", "facebook", "checklist"]
    weak var delegate:TutorialViewDelegate?
    
    var pageViewController:UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
        
        //TODO: APARTE VIEW
        let skipButton = UIButton(frame: CGRectMake(view.frame.width-100, view.frame.height-50, 80, 44))
        skipButton.setTitle("SKIP", forState: .Normal)
        skipButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        skipButton.addTarget(self, action: "tappedSkip", forControlEvents: .TouchUpInside)
        self.view.addSubview(skipButton)
    }
    
    func tappedSkip() {
        self.view.window?.rootViewController = MainTabBarController()
    }
    
    func setupPageViewController() {
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController.view.backgroundColor = UIColor.grayColor()
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
    
        let pageContentViewController = self.viewControllerAtIndex(0)
        self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! TutorialContent).pageIndex!
        index++
        if(index >= self.pages.count){
            return nil
        }
        return self.viewControllerAtIndex(index)
    
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! TutorialContent).pageIndex!
        if(index <= 0){
            return nil
        }
        index--
        return self.viewControllerAtIndex(index)
    
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        
        if((self.pages.count == 0) || (index >= self.pages.count)) {
            return nil
        }
        
        switch self.pages[index] {
            
            case "intro":
                let VC = IntroViewController()
                VC.pageIndex = index
                return VC
            
            case "facebook":
                let VC = FBLoginViewController(viewToLoad: .FBTutorialLoginView)
                VC.pageIndex = index
                return VC
            
            case "checklist":
                let VC = ChecklistViewController()
                VC.pageIndex = index
                return VC
            
            default:
                let VC = IntroViewController()
                VC.pageIndex = index
                return VC
            
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
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
