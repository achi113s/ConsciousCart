//
//  ImpulseCategory+CoreDataProperties.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/29/23.
//
//

import Foundation
import CoreData


extension ImpulseCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImpulseCategory> {
        return NSFetchRequest<ImpulseCategory>(entityName: "ImpulseCategory")
    }

    @NSManaged public var categoryName: String?
    @NSManaged public var categoryEmoji: String?
    @NSManaged public var impulses: NSSet?

    public var unwrappedCategoryName: String {
        return categoryName ?? ""
    }
    
    public var unwrappedCategoryEmoji: String {
        return categoryEmoji ?? "😁"
    }
}

// MARK: Generated accessors for impulses
extension ImpulseCategory {

    @objc(addImpulsesObject:)
    @NSManaged public func addToImpulses(_ value: Impulse)

    @objc(removeImpulsesObject:)
    @NSManaged public func removeFromImpulses(_ value: Impulse)

    @objc(addImpulses:)
    @NSManaged public func addToImpulses(_ values: NSSet)

    @objc(removeImpulses:)
    @NSManaged public func removeFromImpulses(_ values: NSSet)

}

extension ImpulseCategory : Identifiable {

}
