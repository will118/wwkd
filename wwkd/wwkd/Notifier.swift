//
//  Notifier.swift
//  wwkd
//
//  Created by will on 12/07/2015.
//  Copyright © 2015 will. All rights reserved.
//

import Foundation

class Notifier : NSObject {
    
    var prophet: Prophet
    
    var timer: NSTimer?
    
    override init() {
        prophet = Prophet()
        super.init()
    }
    
    func backgroundTask(timer:NSTimer) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            self.prophet.sendNotification()
        })
    }
        
    func start() {
        timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: "backgroundTask:", userInfo: nil, repeats: true)
    }

}