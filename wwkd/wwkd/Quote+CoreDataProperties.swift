//
//  Quote+CoreDataProperties.swift
//  wwkd
//
//  Created by will on 15/07/2015.
//  Copyright © 2015 will. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Quote {

    @NSManaged var shows: NSNumber?
    @NSManaged var id: NSNumber?
    @NSManaged var source: String?
    @NSManaged var body: String?
    @NSManaged var ups: NSNumber?
    @NSManaged var downs: NSNumber?

}
