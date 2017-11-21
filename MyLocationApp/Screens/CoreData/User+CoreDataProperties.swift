//
//  User+CoreDataProperties.swift
//  
//
//  Created by Vladyslav Gusakov on 11/19/17.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var phoneNumber: String?
    @NSManaged public var isLoggedIn: Bool

}
