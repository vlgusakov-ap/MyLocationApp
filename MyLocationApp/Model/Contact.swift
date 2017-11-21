//
//  Contact.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/19/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import Contacts

struct Contact {
    let name: String
    let phoneNumber: String
    
    init?(cnContact: CNContact) {
        self.name = "\(cnContact.givenName) \(cnContact.familyName)"
        guard let cnPhoneNumber = cnContact.phoneNumbers.first else { return nil }
        self.phoneNumber = cnPhoneNumber.value.stringValue
    }
    
    init(name: String, phoneNumber: String) {
        self.name = name
        self.phoneNumber = phoneNumber
    }
}
