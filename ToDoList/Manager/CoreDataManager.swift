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
        let sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: false)
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
        newCategory.createdDate = Date()
    
        do {
            try context.save()
            return newCategory
        } catch {
            print("Error creating category: \(error)")
            return nil
        }
    }
    
    // MARK: - Delete Category
    func deleteCategory(category: Kategori) {
        context.delete(category)
        saveContext()
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
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching tasks: \(error)")
            return []
        }
    }

    // MARK: - Create ToDoList Item
    func createItem(name: String, dueDate: Date, reminderTime: Date?, color: UIColor, category: Kategori, notificationID: String?) -> ToDoListitem? {
        let newItem = ToDoListitem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        newItem.dueDate = dueDate
        newItem.reminderTime = reminderTime
        newItem.isCompleted = false
        newItem.color = NSKeyedArchiver.archivedData(withRootObject: color)
        newItem.category = category
        newItem.notificationID = notificationID

        do {
            try context.save()
            return newItem
        } catch {
            print("Error creating item: \(error)")
            return nil
        }
    }

    // MARK: - Update ToDoList Item
    func updateItem(item: ToDoListitem, newName: String, newDueDate: Date, newReminderTime: Date?, newNotificationID: String) -> Bool {
        item.name = newName
        item.dueDate = newDueDate
        item.reminderTime = newReminderTime
        item.notificationID = newNotificationID // Bildirim ID'si güncelleniyor
        return saveContext() // Değişiklikleri kaydet
    }
    // MARK: - Delete ToDoList Item
    func deleteItem(item: ToDoListitem) -> Bool {
        context.delete(item)
        return saveContext()
    }
    
    // MARK: - Fetch Items by Due Date (for specific day)
    func fetchItems(forDate date: Date) -> [ToDoListitem] {
        let fetchRequest: NSFetchRequest<ToDoListitem> = ToDoListitem.fetchRequest()
        
       
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        
        fetchRequest.predicate = NSPredicate(format: "dueDate >= %@ AND dueDate < %@", startOfDay as NSDate, endOfDay as NSDate)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching items by date: \(error)")
            return []
        }
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
    
    func fetchTaskDatesWithCategoryColors() -> [Date: UIColor] {
        let fetchRequest: NSFetchRequest<ToDoListitem> = ToDoListitem.fetchRequest()
        var taskDatesWithColors: [Date: UIColor] = [:]
        
        do {
            let items = try context.fetch(fetchRequest)
            for item in items {
                if let dueDate = item.dueDate,
                   let category = item.category,
                   let colorData = category.color,
                   let color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor {
                    taskDatesWithColors[dueDate] = color 
                }
            }
        } catch {
            print("Error fetching items with category colors: \(error)")
        }
        
        return taskDatesWithColors
    }
    
    // MARK: - Fetch Task Color for Specific Date
    func fetchTaskColor(forDate date: Date) -> UIColor? {
        let fetchRequest: NSFetchRequest<ToDoListitem> = ToDoListitem.fetchRequest()
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        fetchRequest.predicate = NSPredicate(format: "dueDate >= %@ AND dueDate < %@", startOfDay as NSDate, endOfDay as NSDate)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            let items = try context.fetch(fetchRequest)
            
            // Eğer ilgili tarihte en az bir görev varsa, ilk görevin kategorisinin rengini döner
            if let firstItem = items.first,
               let colorData = firstItem.category?.color,
               let color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor {
                return color
            }
        } catch {
            print("Error fetching task color for date: \(error)")
        }
        
        return nil
    }
}
