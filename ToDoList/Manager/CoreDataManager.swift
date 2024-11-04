//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Murat Çimen on 1.11.2024.
//

import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private let context: NSManagedObjectContext
    
    private init() {
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // MARK: - Fetch All Items
    func fetchAllItems() -> [ToDoListitem] {
        let request = ToDoListitem.fetchRequest() as NSFetchRequest<ToDoListitem>
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching items: \(error)")
            return []
        }
    }
    
    // MARK: - Create Item
    func createItem(name: String, dueDate: Date, color: UIColor) -> ToDoListitem? {
        let newItem = ToDoListitem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        newItem.dueDate = dueDate
        newItem.isCompleted = false
        newItem.index = Int32(fetchAllItems().count)

        newItem.color = NSKeyedArchiver.archivedData(withRootObject: color)
        
        do {
            try context.save()
            return newItem
        } catch {
            print("Error creating item: \(error)")
            return nil
        }
    }
    
    // MARK: - Update Item
    func updateItem(item: ToDoListitem, newName: String, newDueDate: Date) -> Bool {
        item.name = newName
        item.dueDate = newDueDate
        
        return saveContext()
    }
    
    // MARK: - Delete Item
    func deleteItem(item: ToDoListitem) -> Bool {
        context.delete(item)
        return saveContext()
    }
    
    // MARK: - Save Context
    func saveContext() -> Bool {
        do {
            try context.save()
            return true
        } catch {
            print("Error saving context: \(error)")
            return false
        }
    }
}
