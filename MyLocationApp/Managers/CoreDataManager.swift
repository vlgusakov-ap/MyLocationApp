//
//  CoreDataManager.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/19/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    lazy var container: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {
        Logger.log("Core Data initialized:\n", context.registeredObjects, type: .checkmark)
        
        context.contacts.forEach { contact in
            Logger.log("CONTACT:", contact.phoneNumber ?? "UNAVAILABLE", type: .none)
            Logger.log("SENT:")
            contact.sentPlaces?.forEach { place in
                Logger.log((place as! PlaceData).name ?? "UNAVAILABLE")
            }
            Logger.log("RECEIVED:")
            contact.receivedPlaces?.forEach { place in
                Logger.log((place as! PlaceData).name ?? "UNAVAILABLE")
            }
        }
        
        context.places.forEach { place in
            Logger.log("PLACE:", place.name ?? "INVALID", type: .none)
            Logger.log("SENT TO:")
            place.sentToContacts?.forEach { contact in
                Logger.log((contact as! ContactData).phoneNumber ?? "UNAVAILABLE")
            }
            Logger.log("RECEIVED FROM:")
            place.receivedFromContacts?.forEach { contact in
                Logger.log((contact as! ContactData).phoneNumber ?? "UNAVAILABLE")
            }
        }
    }
    
    //MARK: - Actions
    func create<T: NSManagedObject>() -> T {
        let entityName = "\(T.self)"
        let object = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! T
        return object
    }
    
    func performAsync(_ block: @escaping () -> Void) {
        context.perform {
            block()
            self.saveContext()
        }
    }
    
    func performSync(_ block: () -> Void) {
        context.performAndWait {
            block()
            self.saveContext()
        }
    }   
    
    func fetchObject<T: NSManagedObject>(predicate: NSPredicate? = nil) -> T? {
        
        var object: T?
                
        performSync {
            let request = T.fetchRequest() as! NSFetchRequest<T>
            request.predicate = predicate
            request.fetchLimit = 1
            
            do {
                let results = try request.execute()
                object = results.first
                
            } catch {
                Logger.log(error, type: .error)
            }
        }
        
        return object
    }
    
    func fetchObjects<T: NSManagedObject>(predicate: NSPredicate? = nil) -> [T] {
        var objects: [T] = []
        
        performSync {
            let request = T.fetchRequest() as! NSFetchRequest<T>
            request.predicate = predicate
            request.fetchLimit = 1000
            
            do {
                let results = try request.execute()
                objects = results
                
            } catch {
                Logger.log(error, type: .error)
            }
        }
        
        return objects
    }
    
    func deleteObject(_ object: NSManagedObject?) {
        guard let object = object else { return }
        performSync {
            context.delete(object)
        }
    }
    
    // MARK: - Saving support
    func saveContext () {
        
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
