//
//  Prophet.swift
//  wwkd
//
//  Created by will on 12/07/2015.
//  Copyright © 2015 will. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class QuoteLibrary {
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    var lib: [Quote]?
    
    init() {
        loadAll()
    }
    
    func loadAll() {
        let request = NSFetchRequest()
        
        request.entity = NSEntityDescription.entityForName("Quote", inManagedObjectContext: managedObjectContext)
        request.predicate = NSPredicate(value: true)
        
        do {
            let objects = try managedObjectContext.executeFetchRequest(request)
            
            if objects.count > 0 {
                if let quotes = objects as? [Quote] {
                    lib = quotes
                }
            } else {
                if let path = NSBundle.mainBundle().pathForResource("quotes_library", ofType: "json") {
                    if let quotes = parseJson(path) {
                        lib = quotes
                        saveLibrary()
                    }
                }
            }
        } catch {}
    }
   
    private func parseJson(path: String) -> [Quote]? {
        if let data = NSData(contentsOfFile: path) {
           do {
               let jsonDict = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray
            
                if let entity = NSEntityDescription.entityForName(Quote.entityName, inManagedObjectContext: managedObjectContext) {
                    return jsonDict?.map { (x) -> Quote in
                       let name = x["source"] as? String
                       let body = x["body"] as? String
                       let id = x["id"] as? Int
                       
                       let quote = Quote(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
                       quote.source = name
                       quote.body = body
                       quote.id = id
                       return quote
                    }
                } else {
                    return nil
                }
           } catch let error as NSError {
               print(error.description)
               return nil
           }
        } else {
           return nil
        }
    }
    
    func get() -> Quote? {
        if let xs = lib {
            let ys = xs.sort { (a, b) -> Bool in
                return a.shows?.integerValue > b.shows?.integerValue
            }

            let leastShows = ys[0].shows
            
            let least = ys.filter { (x) -> Bool in
                return x.shows == leastShows
            }
            
            let randomIndex = Int(arc4random_uniform(UInt32(least.count)))
            
            let quote = least[randomIndex]
            
            if var q = quote.shows {
                q = q.integerValue + 1
            }
            
            return quote
        } else {
            return nil
        }
    }
    
    func saveLibrary() {
        do {
            if managedObjectContext.hasChanges {
                try managedObjectContext.save()
            }
        } catch {}
    }
    
}



