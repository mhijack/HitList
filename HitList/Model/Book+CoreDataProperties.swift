//
//  Book+CoreDataProperties.swift
//  
//
//  Created by Jianyuan Chen on 2021-02-03.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var title: String?
    @NSManaged public var author: Person?

}
