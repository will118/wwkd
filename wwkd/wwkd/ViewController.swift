//
//  ViewController.swift
//  wwkd
//
//  Created by will on 14/07/2015.
//  Copyright © 2015 will. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var progressBar: CircleProgressBar!
    
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
        updateWheel()
        AppDelegate.notifier?.pushVoteQueue()
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "applicationBecameActive:",
            name: UIApplicationDidBecomeActiveNotification,
            object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

