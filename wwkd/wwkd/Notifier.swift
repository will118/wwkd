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
    
    var token: String
    
    init(tkn: String) {
        quoteLibrary = QuoteLibrary()
        token = tkn
        super.init()
        register()
    }
    
    func requestBlessing() {
        Http.post("blessing", payload: ["token": token])
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
            Http.post("vote", payload: v)
        }
        
    }
    
    private func register() {
        Http.post("register", payload: ["token": token])
    }
    

}