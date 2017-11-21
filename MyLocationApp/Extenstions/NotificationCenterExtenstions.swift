//
//  NotificationCenterExtenstions.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/20/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let didUpdatedUserLocation = Notification.Name(rawValue: "didUpdatedUserLocation")
    static let didChangeLocationAuthorization = Notification.Name(rawValue: "didChangeLocationAuthorization")
}
