//
//  PlaceData+Project.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/20/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import CoreData
import AlecrimCoreData

extension PlaceData {
    
    //MARK: Relationships
    enum Contacts: String {
        case sentToContacts
        case receivedFromContacts
    }
    
    func add(contact: ContactData, to contacts: Contacts) {
        self.mutableSetValue(forKey: contacts.rawValue).add(contact)
    }
    
    func populate(with location: LocationData) {
        self.name = location.name
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.address = location.address
        self.placeId = location.placeId
        
        if (self.timestamp == 0) {
            self.timestamp = Int64(Date().timeIntervalSince1970)
        }
    }
}

// MARK: - PlaceData query attributes
extension PlaceData {
    static let name = Attribute<String>("name")
    static let latitude = Attribute<Double>("latitude")
    static let longitude = Attribute<Double>("longitude")
    static let address = Attribute<String>("address")
    static let placeId = Attribute<String>("placeId")
    static let timestamp = Attribute<Int64>("timestamp")
}

// MARK: - AttributeProtocol extensions
extension AttributeProtocol where Self.ValueType: PlaceData {
    var name: Attribute<String> { return Attribute<String>("name", self) }
    var latitude: Attribute<Double> { return Attribute<Double>("latitude", self) }
    var longitude: Attribute<Double> { return Attribute<Double>("longitude", self) }
    var address: Attribute<String> { return Attribute<String>("address", self) }
    var placeId: Attribute<String> { return Attribute<String>("placeId", self) }
    var timestamp: Attribute<Double> { return Attribute<Double>("timestamp", self) }

}
