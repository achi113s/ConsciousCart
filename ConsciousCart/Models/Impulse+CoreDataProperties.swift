//
//  Impulse+CoreDataProperties.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 6/11/23.
//
//

import Foundation
import CoreData


extension Impulse {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Impulse> {
        return NSFetchRequest<Impulse>(entityName: "Impulse")
    }

    @NSManaged public var dateCreated: Date?
    @NSManaged public var id: UUID
    @NSManaged public var imageName: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var reasonNeeded: String?
    @NSManaged public var remindDate: Date?
    @NSManaged public var completed: Bool
    @NSManaged public var dateCompleted: Date?
    @NSManaged public var amountSaved: Double

    public var unwrappedCreationDate: Date {
        dateCreated ?? Date.now
    }
    
    public var unwrappedName: String {
        name ?? ""
    }
    
    public var unwrappedReasonNeeded: String {
        reasonNeeded ?? "None"
    }
    
    public var unwrappedRemindDate: Date {
        remindDate ?? Date.now
    }
    
    public var unwrappedCompletedDate: Date {
        dateCompleted ?? Date.now
    }
}

extension Impulse : Identifiable {

}
