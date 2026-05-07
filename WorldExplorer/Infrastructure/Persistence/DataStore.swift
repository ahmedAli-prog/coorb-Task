//
//  DataStore.swift
//  WorldExplorer
//
//  Created by ahmed ali on 7/5/26.
//

import CoreData

class DataStore {
    
    static let shared = DataStore()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WorldExplorer")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
