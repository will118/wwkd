//
//  Prophet.swift
//  wwkd
//
//  Created by will on 12/07/2015.
//  Copyright © 2015 will. All rights reserved.
//

import UIKit


class Quote {
    var source: String?
    var body: String?
    var credibility: Int = 0
    var shows: Int = 0
    var ups: Int = 0
    var downs: Int = 0
}


class QuoteLibrary {
    var lib: [Quote]
    
    init(quotes: [Quote]) {
        self.lib = quotes
    }
    
    func get() -> Quote {
        let xs = self.lib.sort { (a, b) -> Bool in
            return a.shows > b.shows
        }
        
        let leastShows = xs[0].shows
        
        let least = xs.filter { (x) -> Bool in
            return x.shows == leastShows
        }
        
        let randomIndex = Int(arc4random_uniform(UInt32(least.count)))
        
        let quote = least[randomIndex]
        
        quote.shows++
        
        return quote
    }
    
}


class Prophet {
    
    var quotes: QuoteLibrary
    
    init() {
        self.quotes = QuoteLibrary(quotes: [])
        if let path = NSBundle.mainBundle().pathForResource("quotes", ofType: "json") {
            if let quotes = parseJson(path) {
                self.quotes.lib = quotes
            }
        }
    }
    
    private func parseJson(path: String) -> [Quote]? {
        if let data = NSData(contentsOfFile: path) {
           do {
               let jsonDict = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSArray
            
                return jsonDict?.reduce([], combine: { (acc, x) -> [Quote] in
                   let name = x["source"] as? String
                   let xs = x["body"] as? NSArray
                   
                   let lib = xs?.map({ (x) -> Quote in
                       let quote = Quote()
                       quote.source = name
                       quote.body = x as? String
                       return quote
                   })
                   
                   if let ys = lib {
                       return acc + ys
                   } else {
                       return acc
                   }
               })
           } catch let error as NSError {
               print(error.description)
               return nil
           }
        } else {
           return nil
        }
    }
    
    func sendNotification() {
        let notif = UILocalNotification()
        notif.alertAction = "What Would Kanye Do"
        notif.alertBody = self.quotes.get().body
        UIApplication.sharedApplication().scheduleLocalNotification(notif)
    }

}

