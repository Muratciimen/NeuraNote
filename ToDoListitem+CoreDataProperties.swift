//
//  ToDoListitem+CoreDataProperties.swift
//  ToDoList
//
//  Created by Murat Çimen on 5.11.2024.
//
//

import Foundation
import CoreData


extension ToDoListitem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListitem> {
        return NSFetchRequest<ToDoListitem>(entityName: "ToDoListitem")
    }

    @NSManaged public var brief: String?
    @NSManaged public var color: Data?
    @NSManaged public var createdAt: Date?
    @NSManaged public var dueDate: Date?
    @NSManaged public var index: Int32
    @NSManaged public var isCompleted: Bool
    @NSManaged public var name: String?
    @NSManaged public var category: String?

}

extension ToDoListitem : Identifiable {

}
