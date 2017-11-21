//
//  Destination.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/4/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import Foundation

enum Destination {
    case home(destination: HomeDestination)
    case preAccount(destination: PreAccountDestination)
    case settings
}

extension Destination {
    enum HomeDestination {
        case main
        case placeDetail(PlaceData)
        case placesDetail([PlaceData])
    }
    
    enum PreAccountDestination {
        case main
    }
}
