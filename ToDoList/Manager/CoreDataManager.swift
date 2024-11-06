//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Murat Çimen on 1.11.2024.
//

import CoreData
import UIKit

class CoreDataManager {
    
    // Singleton örneği
    static let shared = CoreDataManager()
    
    // Core Data konteksi
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
        newCategory.color = NSKeyedArchiver.archivedData(withRootObject: color) // `Data` olarak kaydediliyor

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
        let request = ToDoListitem.fetchRequest() as NSFetchRequest<ToDoListitem>
        request.predicate = NSPredicate(format: "category == %@", category) // İlgili kategoriye göre filtreleme
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching items for category: \(error)")
            return []
        }
    }
    
    // MARK: - Create ToDoList Item
    func createItem(name: String, dueDate: Date, color: UIColor, category: Kategori) -> ToDoListitem? {
        // 1. Aynı ada sahip bir görev olup olmadığını kontrol ediyoruz
        let request = ToDoListitem.fetchRequest() as NSFetchRequest<ToDoListitem>
        request.predicate = NSPredicate(format: "name == %@ AND category == %@", name, category)

        do {
            let existingTasks = try context.fetch(request)
            if !existingTasks.isEmpty {
                print("Task with this name already exists.")
                return nil // Aynı ada sahip bir görev varsa, yeni görev eklenmiyor
            }
        } catch {
            print("Error checking for existing task: \(error)")
            return nil
        }

        // 2. Yeni görevi ekleme işlemi
        let newItem = ToDoListitem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        newItem.dueDate = dueDate
        newItem.isCompleted = false
        newItem.color = NSKeyedArchiver.archivedData(withRootObject: color)
        newItem.category = category

        do {
            try context.save()
            print("Task successfully saved to CoreData.")
            return newItem
        } catch {
            print("Error creating item: \(error)")
            return nil
        }
    }


    
    // MARK: - Update ToDoList Item
    func updateItem(item: ToDoListitem, newName: String, newDueDate: Date) -> Bool {
        item.name = newName
        item.dueDate = newDueDate
        
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
