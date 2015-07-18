//
//  Http.swift
//  wwkd
//
//  Created by will on 18/07/2015.
//  Copyright © 2015 will. All rights reserved.
//

import Foundation

class Http {
    
    static var host = "http://kush.io"
    
    static func get(endPoint: String) -> AnyObject? {
        if let data = getJSON(host + "/" + endPoint) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            } catch { return nil }
        } else {
            return nil
        }
    }
    
    private static func getJSON(urlToRequest: String) -> NSData? {
        return NSURL(string: urlToRequest) >>> { x in NSData(contentsOfURL: x) }
    }
    
    static func post(endPoint: String, payload:Dictionary<String, String>) {
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
    
    static func handler (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void {
        if let e = error {
            print(e.description)
        }
    }
}