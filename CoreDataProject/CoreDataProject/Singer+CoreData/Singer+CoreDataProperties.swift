//
//  Singer+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Robert Shrestha on 9/7/20.
//  Copyright © 2020 robert. All rights reserved.
//
//

import Foundation
import CoreData


extension Singer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Singer> {
        return NSFetchRequest<Singer>(entityName: "Singer")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?

     var wrappedFirstName: String {
        return firstName ?? "Unknown first name"
    }
     var wrappedLastName: String {
        return lastName ?? "Unknown last name"
    }

}
