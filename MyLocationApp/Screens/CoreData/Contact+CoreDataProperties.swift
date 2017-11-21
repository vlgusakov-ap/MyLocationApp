//
//  Contact+CoreDataProperties.swift
//  
//
//  Created by Vladyslav Gusakov on 11/19/17.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: NSObject?
    @NSManaged public var sentPlaces: NSSet?
    @NSManaged public var receivedPlaces: NSSet?

}

// MARK: Generated accessors for sentPlaces
extension Contact {

    @objc(addSentPlacesObject:)
    @NSManaged public func addToSentPlaces(_ value: Place)

    @objc(removeSentPlacesObject:)
    @NSManaged public func removeFromSentPlaces(_ value: Place)

    @objc(addSentPlaces:)
    @NSManaged public func addToSentPlaces(_ values: NSSet)

    @objc(removeSentPlaces:)
    @NSManaged public func removeFromSentPlaces(_ values: NSSet)

}

// MARK: Generated accessors for receivedPlaces
extension Contact {

    @objc(addReceivedPlacesObject:)
    @NSManaged public func addToReceivedPlaces(_ value: Place)

    @objc(removeReceivedPlacesObject:)
    @NSManaged public func removeFromReceivedPlaces(_ value: Place)

    @objc(addReceivedPlaces:)
    @NSManaged public func addToReceivedPlaces(_ values: NSSet)

    @objc(removeReceivedPlaces:)
    @NSManaged public func removeFromReceivedPlaces(_ values: NSSet)

}
