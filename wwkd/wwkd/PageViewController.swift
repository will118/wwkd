//
//  PageViewController.swift
//  wwkd
//
//  Created by will on 19/07/2015.
//  Copyright © 2015 will. All rights reserved.
//

import Foundation


class PageViewController : UIPageViewController, UIPageViewControllerDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        if let dialVc = storyboard?.instantiateViewControllerWithIdentifier("dial") {
            setViewControllers([dialVc], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if viewController.isKindOfClass(DialViewController) {
            return nil
        } else {
            return storyboard?.instantiateViewControllerWithIdentifier("dial")
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if viewController.isKindOfClass(SettingsViewController) {
            return nil
        } else {
            return storyboard?.instantiateViewControllerWithIdentifier("settings")
        }
    }
    
}