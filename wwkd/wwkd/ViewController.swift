//
//  ViewController.swift
//  wwkd
//
//  Created by will on 14/07/2015.
//  Copyright © 2015 will. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func blessButton(sender: AnyObject) {
        if let n = AppDelegate.notifier {
            n.requestBlessing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

