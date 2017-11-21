//
//  NSManagedObjectContext+Project.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/20/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import CoreData
import AlecrimCoreData

extension NSManagedObjectContext {
    var users: Table<UserData> { return Table<UserData>(context: self) }
    var contacts: Table<ContactData> { return Table<ContactData>(context: self) }
    var places: Table<PlaceData> { return Table<PlaceData>(context: self) }
    
    var currentUser: UserData? {
        guard users.count() <= 1 else { fatalError("Only one user is supported") }
        return users.first()
    }
    
    var currentUserContact: ContactData? {
        guard let phoneNumber = currentUser?.phoneNumber else { return nil }
        var contact: ContactData?
        performSync {
            contact = self.contacts.firstOrCreated { $0.phoneNumber == phoneNumber }
        }
        return contact
    }
    
    func saveChanges() {
        guard self.hasChanges else { return }
        
        do {
            try self.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func performAsync(_ block: @escaping () -> Void) {
        self.perform {
            block()
            self.saveChanges()
        }
    }
    
    func performSync(_ block: () -> Void) {
        self.performAndWait {
            block()
           self.saveChanges()
        }
    }
}
