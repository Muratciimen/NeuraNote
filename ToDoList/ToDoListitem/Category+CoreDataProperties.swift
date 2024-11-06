//
//  Category+CoreDataProperties.swift
//  ToDoList
//
//  Created by Murat Çimen on 5.11.2024.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?

}

extension Category : Identifiable {

}
