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
    
    // MARK: - Fetch All Categories
    func fetchAllCategories() -> [Kategori] {
        let request = Kategori.fetchRequest() as NSFetchRequest<Kategori>
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching categories: \(error)")
            return []
        }
    }
    
    // MARK: - Create Category
    func createCategory(name: String, color: UIColor) -> Kategori? {
        let newCategory = Kategori(context: context)
        newCategory.id = UUID()
        newCategory.name = name
        newCategory.color = NSKeyedArchiver.archivedData(withRootObject: color)

        do {
            try context.save()
            return newCategory
        } catch {
            print("Error creating category: \(error)")
            return nil
        }
    }
    
    // MARK: - Delete Category
    func deleteCategory(category: Kategori) -> Bool {
        context.delete(category)
        return saveContext()
    }
    
    // MARK: - Fetch All ToDoList Items
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
    
    // MARK: - Fetch Items by Category
    func fetchItems(byCategory category: Kategori) -> [ToDoListitem] {
        let fetchRequest: NSFetchRequest<ToDoListitem> = ToDoListitem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "category == %@", category)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching tasks: \(error)")
            return []
        }
    }
    
    // MARK: - Create ToDoList Item
    func createItem(name: String, dueDate: Date, reminderTime: Date?, color: UIColor, category: Kategori) -> ToDoListitem? {
        let newItem = ToDoListitem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        newItem.dueDate = dueDate
        newItem.reminderTime = reminderTime
        newItem.isCompleted = false
        newItem.color = NSKeyedArchiver.archivedData(withRootObject: color)
        newItem.category = category



        print("Core Data'ya kaydedilen Task:")
        print("Name: \(newItem.name)")
        print("Due Date: \(newItem.dueDate ?? Date())")
        print("Reminder Time: \(newItem.reminderTime ?? Date())")
        print("Description (Brief): \(newItem.brief ?? "Açıklama yok")")

        do {
            try context.save()
            return newItem
        } catch {
            print("Error creating item: \(error)")
            return nil
        }
    }


    // MARK: - Update ToDoList Item
    func updateItem(item: ToDoListitem, newName: String, newDueDate: Date, newReminderTime: Date?) -> Bool {
        item.name = newName
        item.dueDate = newDueDate
        item.reminderTime = newReminderTime
        
        return saveContext()
    }
    
    // MARK: - Delete ToDoList Item
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
