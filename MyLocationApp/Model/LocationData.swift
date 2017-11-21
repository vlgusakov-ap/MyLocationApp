//
//  LocationData.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/4/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import Foundation
import CoreLocation
import GooglePlaces

struct LocationData {
    let name: String
    let coordinate: CLLocationCoordinate2D
    let address: String
    let placeId: String
    
    init(name: String, coordinate: CLLocationCoordinate2D, address: String, placeId: String) {
        self.name = name
        self.coordinate = coordinate
        self.address = address
        self.placeId = placeId
    }
    
    init?(gmsPlace: GMSPlace) {
        guard let address = gmsPlace.formattedAddress else { return nil }
        self.name = gmsPlace.name
        self.coordinate = gmsPlace.coordinate
        self.address = address
        self.placeId = gmsPlace.placeID
    }
    
    //example - mylocation://placeId=1&phoneNumber=123
    init?(url: URL) {
        guard url.scheme == "mylocation",
              url.pathComponents.count == 5 else { return nil }
        
        guard let latitude = Double(url.pathComponents[1]),
              let longitude = Double(url.pathComponents[2]) else {
                return nil
        }
        
        let placeName = url.pathComponents[3]
        let placeAddress = url.pathComponents[4]
        let placeId = url.pathComponents[1]
        
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.name = placeName
        self.address = placeAddress
        self.placeId = placeId
    }
}
