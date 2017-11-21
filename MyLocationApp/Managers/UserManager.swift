//
//  UserManager.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/19/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import Foundation
import CoreData

class UserManager {
    
    static let shared = UserManager()
    
    var currentUser: UserData?
    
    var isLoggedIn: Bool {
        
        if currentUser != nil {
            return true
        }
        
        currentUser = dbUser
                
        return currentUser != nil
    }
    
    private var dbUser: UserData? {
        return CoreDataManager.shared.fetchObject(predicate: NSPredicate.isLoggedIn)
    }
    
    func logout() {
        CoreDataManager.shared.deleteObject(currentUser)
        currentUser = nil
        Router.show(destination: .preAccount(destination: .main), presentationStyle: .modal)
    }
}

