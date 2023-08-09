//
//  ConsciousCartDataManager.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/30/23.
//

import CoreData
import Foundation
import UniformTypeIdentifiers


// trying this out in new branch
class CoreDataManager {
    //MARK: - Properties
    
    private let modelName: String
    
    //MARK: - Initialization
    
    public init(modelName: String) {
        self.modelName = modelName
    }
    
    //MARK: - CoreData Stack
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // Fetch the model URL.
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to find data model.")
        }
        
        // Initialize Managed Object Model
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to load data model.")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
       // Initialize Persistent Store Coordinator
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let storeName = "\(self.modelName).sqlite"
        
        let persistentStoreURL = FileManager.documentsDirectory.appendingPathComponent(storeName, conformingTo: .database)

        do {
            let options = [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]
            
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: options)
        } catch {
            fatalError("Unable to add persistent store: \(error.localizedDescription)")
        }
        
        return persistentStoreCoordinator
    }()
    
    // This managed object context will be tied to a private background thread.
    // We will use a public managed object context tied to the main thread for doing
    // anything associated with the UI. Data writes will be pushed from the main one to
    // this private one. The private one will talk to the persistent store coordinator
    // for actual writing of data, preventing a data write from locking up our UI.
    private lazy var privateManagedObjectContext: NSManagedObjectContext = {
       // Initialize Managed Object Context
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    public private(set) lazy var mainManagedObjectContext: NSManagedObjectContext = {
       // Initialize Managed Object context
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.parent = self.privateManagedObjectContext
        
        return managedObjectContext
    }()
    
    //MARK: - Public API
    
    public func saveChanges() {
        // Save changes on the main managed object context
        // and push them to the private managed object context.
        mainManagedObjectContext.performAndWait {
            do {
                if self.mainManagedObjectContext.hasChanges {
                    try self.mainManagedObjectContext.save()
                }
                print("saved public MOC")
            } catch {
                print("Unable to save changes of main managed object context.")
                print("\(error), \(error.localizedDescription)")
            }
        }
        
        // Asynchronously save changes on the private managed object context
        // and push the changes to the persistent store coordinator.
        privateManagedObjectContext.perform {
            do {
                if self.privateManagedObjectContext.hasChanges {
                    try self.privateManagedObjectContext.save()
                }
                print("saved private MOC")
            } catch {
                print("Unable to save changes of private managed object context.")
                print("\(error), \(error.localizedDescription)")
            }
        }
    }
    
    public func deleteObject(object: NSManagedObject) {
        mainManagedObjectContext.performAndWait {
            self.mainManagedObjectContext.delete(object)
        }

        saveChanges()
    }
}
