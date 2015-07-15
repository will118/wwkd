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
    
    static func register(token: String) {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://192.168.1.94:3000/register")!)
        request.HTTPMethod = "POST"
        request.allowsCellularAccess = false
        
        let params = ["token": token] as Dictionary<String, String>
        
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        } catch {
            print("Error adding params to POST")
        }
        
        func handler (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void {
            print(error?.description)
        }
        
        let session = NSURLSession.sharedSession()
        
        if let t = session.dataTaskWithRequest(request, completionHandler: handler) {
            t.resume()
        }
    }

}