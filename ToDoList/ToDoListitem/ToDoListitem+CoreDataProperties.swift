//
//  ToDoListitem+CoreDataProperties.swift
//  ToDoList
//
//  Created by Murat Çimen on 14.10.2024.
//
//

import Foundation
import CoreData


extension ToDoListitem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListitem> {
        return NSFetchRequest<ToDoListitem>(entityName: "ToDoListitem")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?

}

extension ToDoListitem : Identifiable {

}
