//
//  Person+CoreDataProperties.swift
//  
//
//  Created by Jianyuan Chen on 2021-02-03.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var age: Int32
    @NSManaged public var name: String?
    @NSManaged public var wrote: Book?

}
