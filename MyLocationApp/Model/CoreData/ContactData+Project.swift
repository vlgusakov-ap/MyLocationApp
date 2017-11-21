//
//  ContactData+Project.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/20/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import CoreData
import AlecrimCoreData

protocol ContactDataShareable {
    func share(location: LocationData, with contacts: [Contact])
}

extension ContactData {
    
    //MARK: Relationships
    enum Places: String {
        case sentPlaces
        case receivedPlaces
    }
    
    func add(place: PlaceData, to places: Places) {
        self.mutableSetValue(forKey: places.rawValue).add(place)
    }
    
    func populate(with contact: Contact) {
        self.name = contact.name
        self.phoneNumber = contact.phoneNumber
    }
    
    func populate(with user: UserData) {
        self.phoneNumber = user.phoneNumber
    }
}


// MARK: - ContactData query attributes
extension ContactData {
    static let name = Attribute<String>("name")
    static let phoneNumber = Attribute<String>("phoneNumber")
    static let timestamp = Attribute<Int64>("timestamp")
}

// MARK: - AttributeProtocol extensions
extension AttributeProtocol where Self.ValueType: ContactData {
    
    var name: AlecrimCoreData.Attribute<String> { return Attribute<String>("name", self) }
    var phoneNumber: AlecrimCoreData.Attribute<String> { return Attribute<String>("phoneNumber", self) }
    var timestamp: Attribute<Double> { return Attribute<Double>("timestamp", self) }
}

extension NSManagedObjectContext: ContactDataShareable {
    
    func share(location: LocationData, with contacts: [Contact]) {
        self.performAsync {
            contacts.forEach { contact in
                
                //Find or create a contact
                let phoneNumber = PhoneNumberFormatter.phoneNumber(from: contact.phoneNumber)
                let contactData = self.contacts.firstOrCreated {
                    $0.phoneNumber == phoneNumber
                }
                
                contactData.phoneNumber = phoneNumber
                
                //Make sure creation date is set
                if (contactData.timestamp == 0) {
                    contactData.timestamp = Int64(Date().timeIntervalSince1970)
                }
                
                //Find or create a place
                let place = self.places.firstOrCreated { $0.placeId == location.placeId }
                place.populate(with: location)
                
                //Add place to contact
                contactData.add(place: place, to: .receivedPlaces)
                self.currentUserContact?.add(place: place, to: .sentPlaces)
            }
        }
    }
}
