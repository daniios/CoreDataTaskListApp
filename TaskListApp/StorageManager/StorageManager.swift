//
//  StorageManager.swift
//  TaskListApp
//
//  Created by Даниил Чупин on 02.07.2023.
//

import Foundation
import CoreData

final class CoreDataHelper {
    static let shared = CoreDataHelper()
    
    private let persistentContainer: NSPersistentContainer
    
    private lazy var viewContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "TaskListApp")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func saveContext() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    func fetchData() -> [Task] {
        let fetchRequest = Task.fetchRequest()
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print(error)
            return []
        }
    }
    
    func save(_ taskName: String) {
        let task = Task(context: viewContext)
        task.title = taskName
        
        saveContext()
    }
    
    func update(_ task: Task) {
        saveContext()
    }
    
    func delete(_ task: Task) {
        viewContext.delete(task)
        
        saveContext()
    }
}
