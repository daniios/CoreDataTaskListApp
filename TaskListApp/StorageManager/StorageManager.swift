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
    
    private lazy var viewContext = persistentContainer.viewContext
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "TaskListApp")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
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
    
    func save(_ taskName: String) -> Task? {
        let task = Task(context: viewContext)
        task.title = taskName

        do {
            try viewContext.save()
            return task
        } catch {
            print(error)
            return nil
        }
    }
    
    func update(_ task: Task, withName newName: String) {
        task.title = newName
        saveContext()
    }
    
    func delete(_ task: Task) {
        viewContext.delete(task)
        
        saveContext()
    }
}
