//
//  UserStats+CoreDataProperties.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/30/23.
//
//

import Foundation
import CoreData


extension UserStats {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserStats> {
        return NSFetchRequest<UserStats>(entityName: "UserStats")
    }

    @NSManaged public var id: UUID
    @NSManaged public var userName: String?
    @NSManaged public var totalAmountSaved: Double
    @NSManaged public var level: Int16
    @NSManaged public var impulses: NSSet?

    public var unwrappedUserName: String {
        userName ?? "No Name"
    }
}

// MARK: Generated accessors for impulses
extension UserStats {

    @objc(addImpulsesObject:)
    @NSManaged public func addToImpulses(_ value: Impulse)

    @objc(removeImpulsesObject:)
    @NSManaged public func removeFromImpulses(_ value: Impulse)

    @objc(addImpulses:)
    @NSManaged public func addToImpulses(_ values: NSSet)

    @objc(removeImpulses:)
    @NSManaged public func removeFromImpulses(_ values: NSSet)

}

extension UserStats : Identifiable {

}
