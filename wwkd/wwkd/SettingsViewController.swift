//
//  SettingsController.swift
//  wwkd
//
//  Created by will on 19/07/2015.
//  Copyright © 2015 will. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var frequency: UISegmentedControl!
    @IBOutlet weak var toggle: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frequency.addTarget(self, action: "changed:", forControlEvents:.AllEvents)
        let savedFreq = 3
        
        var index : Int
        
        switch savedFreq {
        case 1:
            index = 0
        case 3:
            index = 1
        case 5:
            index = 2
        default:
            index = -1
        }
        
        
        let savedSubscription = true
        frequency.selectedSegmentIndex = index
        toggle.setOn(savedSubscription, animated: false)
    }

    @IBAction func changed(sender: AnyObject) {
        if let n = AppDelegate.notifier {
            var freq : Int
            switch frequency.selectedSegmentIndex {
            case 0:
                freq = 1
            case 1:
                freq = 3
            case 2:
                freq = 5
            default:
                freq = 1
            }
            n.subscribeSettings(toggle.on, frequency: freq)
        }
    }
}