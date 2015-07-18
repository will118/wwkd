//
//  Operators.swift
//  wwkd
//
//  Created by will on 18/07/2015.
//  Copyright © 2015 will. All rights reserved.
//

import Foundation

infix operator >>> { associativity left precedence 150 }

func >>><A, B>(a: A?, f: A -> B?) -> B? {
    if let x = a {
        return f(x)
    } else {
        return .None
    }
}