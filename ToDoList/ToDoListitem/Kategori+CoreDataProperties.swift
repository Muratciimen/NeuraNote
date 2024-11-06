//
//  Kategori+CoreDataProperties.swift
//  ToDoList
//
//  Created by Murat Çimen on 5.11.2024.
//
//

import Foundation
import CoreData


extension Kategori {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Kategori> {
        return NSFetchRequest<Kategori>(entityName: "Kategori")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var color: Data?
    @NSManaged public var items: Set<ToDoListitem>?

}

extension Kategori : Identifiable {

}
