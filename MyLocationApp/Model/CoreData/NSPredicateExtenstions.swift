//
//  NSPredicateExtenstions.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/19/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import CoreData

extension NSPredicate {
    static var isLoggedIn: NSPredicate {
        return NSPredicate(format: "%K == true", "isLoggedIn")
    }
}
