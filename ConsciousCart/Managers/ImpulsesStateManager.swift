//
//  CoreDataMOCManager.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 6/26/23.
//

import CoreData

final class ImpulsesStateManager {
    private var moc: NSManagedObjectContext?
    
    private(set) var impulses: [Impulse] = [Impulse]()
    private(set) var completedImpulses: [Impulse] = [Impulse]()
    
    init(moc: NSManagedObjectContext? = nil) {
        self.moc = moc
        
        loadImpulses()
    }
    
    public func setMOC(moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
    private func loadImpulses(with request: NSFetchRequest<Impulse> = Impulse.fetchRequest()) {
        guard let moc = moc else { return }
        
        do {
            request.sortDescriptors = [NSSortDescriptor(key:"dateCreated", ascending:true)]
            let allImpulses = try moc.fetch(request)
            
            self.impulses = allImpulses.filter { !$0.completed }
            self.completedImpulses = allImpulses.filter { $0.completed }.sorted(by: { $0.wrappedCompletedDate < $1.wrappedCompletedDate })
        } catch {
            print("Error fetching data from context: \(error.localizedDescription)")
        }
    }
    
    private func saveImpulses() {
        guard let moc = moc else { return }
        
        do {
            try moc.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
    
    public func addImpulse(
        remindDate: Date = Date(),
        name: String = "Unknown Name",
        price: Double = 0.0,
        imageName: String? = nil,
        reasonNeeded: String = "Unknown Reason") {
            guard let moc = moc else { return }
            
            let newImpulse = Impulse(context: moc)
            newImpulse.id = UUID()
            newImpulse.dateCreated = Date.now
            newImpulse.remindDate = remindDate
            newImpulse.name = name
            newImpulse.price = price
            newImpulse.imageName = imageName
            newImpulse.reasonNeeded = reasonNeeded
            newImpulse.completed = false
            
            saveImpulses()
        }
    
    public func deleteAllImpulses() {
        guard let moc = moc else { return }
        
        do {
            let allImpulses = try moc.fetch(Impulse.fetchRequest())
            
            for impulse in allImpulses {
                // Delete the image in the Documents directory if it exists.
                if let imageName = impulse.imageName {
                    let imagePathName = FileManager.documentsDirectory.appendingPathComponent(imageName, conformingTo: .png)
                    do {
                        try FileManager.default.removeItem(at: imagePathName)
                    } catch {
                        print("Could not delete Impulse's image: \(error.localizedDescription)")
                    }
                }
                
                moc.delete(impulse)
            }
            
            saveImpulses()
        } catch {
            print("Error deleting data from context: \(error.localizedDescription)")
        }
    }
}
