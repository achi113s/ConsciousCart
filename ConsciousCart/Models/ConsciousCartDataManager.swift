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
class ConsciousCartDataManager {
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
    
    public private(set) lazy var managedObjectContext: NSManagedObjectContext = {
       // Initialize Managed Object Context
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
}
