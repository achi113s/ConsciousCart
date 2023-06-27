//
//  CoreDataMOCManager.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 6/26/23.
//

import CoreData

final class ImpulseDataManager {
    static public func addImpulse(moc: NSManagedObjectContext,
                                  remindDate: Date = Date(),
                                  name: String = "Unknown Name",
                                  price: Double = 0.0,
                                  reasonNeeded: String = "Unknown Reason") {
        let newImpulse = Impulse(context: moc)
        newImpulse.id = UUID()
        newImpulse.dateCreated = Date.now
        newImpulse.remindDate = remindDate
        newImpulse.name = name
        newImpulse.price = price
        newImpulse.reasonNeeded = reasonNeeded
        newImpulse.completed = false
        
        saveMOC(moc: moc)
    }
    
    static public func deleteAllImpulses(moc: NSManagedObjectContext) {
        do {
            let impulses = try moc.fetch(Impulse.fetchRequest())
            
            for impulse in impulses {
                moc.delete(impulse)
            }
            
            saveMOC(moc: moc)
        } catch {
            print("Error deleting data from context: \(error.localizedDescription)")
        }
    }
    
    static public func loadImpulses(
        moc: NSManagedObjectContext,
        with request: NSFetchRequest<Impulse> = Impulse.fetchRequest()
    ) -> ([Impulse], [Impulse]) {
        do {
            request.sortDescriptors = [NSSortDescriptor(key:"dateCreated", ascending:true)]
            let allImpulses = try moc.fetch(request)
            
            let impulses = allImpulses.filter { !$0.completed }
            let completedImpulses = allImpulses.filter { $0.completed }.sorted(by: { $0.wrappedCompletedDate < $1.wrappedCompletedDate })
            
            return (impulses, completedImpulses)
        } catch {
            print("Error fetching data from context: \(error.localizedDescription)")
        }
        
        return ([Impulse](), [Impulse]())
    }
    
    static private func saveMOC(moc: NSManagedObjectContext) {
        do {
            try moc.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
}
