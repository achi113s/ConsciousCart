//
//  Impulse+CoreDataProperties.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 5/20/23.
//
//

import Foundation
import CoreData


extension Impulse {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Impulse> {
        return NSFetchRequest<Impulse>(entityName: "Impulse")
    }

    @NSManaged public var dateCreated: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var imageName: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var reasonNeeded: String?
    @NSManaged public var remindDate: Date?

    public var wrappedName: String {
        name ?? ""
    }
    
    public var wrappedReasonNeeded: String {
        reasonNeeded ?? ""
    }
}

extension Impulse : Identifiable {

}
