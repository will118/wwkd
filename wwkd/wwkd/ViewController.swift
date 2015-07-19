//
//  ViewController.swift
//  wwkd
//
//  Created by will on 14/07/2015.
//  Copyright © 2015 will. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
//    var transition : JTMaterialTransition?
//    
//    var presetControllerButton : UIButton?
    
    var timer : NSTimer?
    
    @IBOutlet weak var progressBar: CircleProgressBar!
    
    @IBOutlet weak var toggle: UISwitch!
    
    @IBAction func subscriptionToggle(sender: AnyObject) {
        if let n = AppDelegate.notifier {
            n.subscribeSettings(toggle.on, frequency: 1)
        }
    }
    
    @IBAction func blessButton(sender: AnyObject) {
        if let n = AppDelegate.notifier {
            n.requestBlessing()
        }
    }
    
    func updateWheel() {
        if let progress = Http.get("prophetic") as? Dictionary<String, Float> {
            if let p = progress["score"] {
                progressBar.setProgress(CGFloat(p), animated: true)
            }
        }
    }
    
    func applicationBecameActive(notification: NSNotification) {
        AppDelegate.notifier?.pushVoteQueue()
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "applicationBecameActive:",
            name: UIApplicationDidBecomeActiveNotification,
            object: nil
        )
        
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "updateWheel", userInfo: nil, repeats: true)
        
        //transition = JTMaterialTransition(animatedView: presetControllerButton);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

