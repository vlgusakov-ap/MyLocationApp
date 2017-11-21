//
//  LocationManager.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/20/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import CoreLocation

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    var currentLocation: CLLocationCoordinate2D?
    
    let locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        return locationManager
    }()
    
    override init() {
        super.init()
        self.setupLocationManager()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
    }
    
    func getUserLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func stopUpdatingLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.stopUpdatingLocation()
        case .denied, .restricted, .notDetermined:
            break
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
        case .denied, .notDetermined, .restricted:
            break
        }
        
        NotificationCenter.default.post(name: .didChangeLocationAuthorization, object: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.currentLocation = location.coordinate
        NotificationCenter.default.post(name: .didUpdatedUserLocation, object: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
