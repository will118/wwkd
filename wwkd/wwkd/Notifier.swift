//
//  Notifier.swift
//  wwkd
//
//  Created by will on 12/07/2015.
//  Copyright © 2015 will. All rights reserved.
//

import Foundation
import UIKit

class Notifier : NSObject {
    
    var quoteLibrary: QuoteLibrary
    
    var timer: NSTimer?
    
    var votes : Array<Dictionary<String, String>> = []
    
    var host = "http://kush.io"
    
    var token: String
    
    init(tkn: String) {
        quoteLibrary = QuoteLibrary()
        token = tkn
        super.init()
        register()
    }
    
    func requestBlessing() {
        post("blessing", payload: ["token": token])
    }
    
    func vote(quoteId: Int, vote: Vote, state: UIApplicationState) {
        var upOrDown : String
        switch vote {
        case .Idiotic:
            upOrDown = "down"
        case .Prophetic:
            upOrDown = "up"
        }
        let dict = ["id": String(quoteId), "vote": upOrDown]
        votes.append(dict)
        switch state {
        case .Active:
            pushVoteQueue()
        default:
            ()
        }
    }
    
    func pushVoteQueue() {
        let vs = Array(votes)
        votes.removeAll()
        for v in vs {
            post("vote", payload: v)
        }
    }
    
    private func register() {
        post("register", payload: ["token": token])
    }
    
    private func handler (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void {
        if let e = error {
            print(e.description)
        }
    }
    
    private func post(endPoint: String, payload:Dictionary<String, String>) {
        let request = NSMutableURLRequest(URL: NSURL(string: host + "/" + endPoint)!)
        request.HTTPMethod = "POST"
        
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(payload, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        } catch {
            print("Error adding params to POST")
        }
        
        let session = NSURLSession.sharedSession()
        
        if let t = session.dataTaskWithRequest(request, completionHandler: handler) {
            t.resume()
        }
    }

}