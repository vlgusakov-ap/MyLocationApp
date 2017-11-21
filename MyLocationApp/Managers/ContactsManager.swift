//
//  ContactsManager.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/4/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import Foundation
import Contacts

final class ContactsManager {
    
    static let shared = ContactsManager()
    
    var isAccessGranted: Bool {
        //        case notDetermined
        //        case restricted
        //        case denied
        //        case authorized
        return CNContactStore.authorizationStatus(for: .contacts) == .authorized
    }
    
    func contactsFromAddressBook(completion: @escaping (Result<[Contact]>) -> Void) {
        
        CNContactStore().requestAccess(for: .contacts) {(isGranted, error) in
            
            guard isGranted else {
                let error = error ?? NSError.with(message: "Couldn't access contacts")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            let keys = [CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey]
            let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
            var contactList: [Contact] = []
            var phoneNumbers: [String] = []
                        
            do {
                try CNContactStore().enumerateContacts(with: request) { (cnContact, stop) in
                    
                    guard let contact = Contact(cnContact: cnContact),
                        !contact.name.isEmpty, !contact.phoneNumber.isEmpty,
                        !phoneNumbers.contains(contact.phoneNumber) else {
                            return
                    }
                    
                    phoneNumbers.append(contact.phoneNumber)
                    contactList.append(contact)
                }
            } catch {
                Logger.log("Failed to fetch contacts", error.localizedDescription, type: .error)
            }
            
            DispatchQueue.main.async {
                completion(.success(contactList))
            }
        }
    }
}
