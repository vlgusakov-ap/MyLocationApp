//
//  Place+CoreDataProperties.swift
//  
//
//  Created by Vladyslav Gusakov on 11/19/17.
//
//

import Foundation
import CoreData


extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var name: String?
    @NSManaged public var address: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var placeId: String?
    @NSManaged public var sentToContacts: NSSet?
    @NSManaged public var receivedFromContacts: NSSet?

}

// MARK: Generated accessors for sentToContacts
extension Place {

    @objc(addSentToContactsObject:)
    @NSManaged public func addToSentToContacts(_ value: Contact)

    @objc(removeSentToContactsObject:)
    @NSManaged public func removeFromSentToContacts(_ value: Contact)

    @objc(addSentToContacts:)
    @NSManaged public func addToSentToContacts(_ values: NSSet)

    @objc(removeSentToContacts:)
    @NSManaged public func removeFromSentToContacts(_ values: NSSet)

}

// MARK: Generated accessors for receivedFromContacts
extension Place {

    @objc(addReceivedFromContactsObject:)
    @NSManaged public func addToReceivedFromContacts(_ value: Contact)

    @objc(removeReceivedFromContactsObject:)
    @NSManaged public func removeFromReceivedFromContacts(_ value: Contact)

    @objc(addReceivedFromContacts:)
    @NSManaged public func addToReceivedFromContacts(_ values: NSSet)

    @objc(removeReceivedFromContacts:)
    @NSManaged public func removeFromReceivedFromContacts(_ values: NSSet)

}
