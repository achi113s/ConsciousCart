//
//  Impulse+CoreDataProperties.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 5/14/23.
//
//

import Foundation
import CoreData


extension Impulse {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Impulse> {
        return NSFetchRequest<Impulse>(entityName: "Impulse")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var remindDate: Date?
    @NSManaged public var name: String?
    @NSManaged public var attribute: String?
    @NSManaged public var price: String?
    @NSManaged public var reasonNeeded: String?

    public var wrappedName: String {
        name ?? ""
    }
    
    public var wrappedPrice: String {
        price ?? ""
    }
    
    public var wrappedReasonNeeded: String {
        reasonNeeded ?? ""
    }
}

extension Impulse : Identifiable {

}
