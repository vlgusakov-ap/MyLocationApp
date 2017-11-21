//
//  MapView.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/20/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import UIKit
import GoogleMaps

class MapView: UIView {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var disabledLocationView: UIVisualEffectView!
    
    var places: [PlaceData] = [] {
        didSet {
            //Center selected place
//            guard places.isEmpty else { return }
            
            //Clear all markers
            self.mapView.clear()
            
            let markers: [GMSMarker] = places.map { place in
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
                marker.title = place.name
                marker.map = mapView
                return marker
            }
            
            let bounds = markers.reduce(GMSCoordinateBounds()) {
                $0.includingCoordinate($1.position)
            }
            
            mapView.setMinZoom(10, maxZoom: 15)
            mapView.animate(with: .fit(bounds, withPadding: 0))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let nib = UINib(nibName: "\(MapView.self)", bundle: nil)
        
        if let subview = nib.instantiate(withOwner: self, options: nil).first as? UIView
        {
            subview.frame = self.bounds
            subview.backgroundColor = UIColor.clear
            self.backgroundColor = UIColor.clear
            
            self.addSubview(subview)
            self.setNeedsDisplay()
        }
        
        configureMap()
        configureUI(with: CLLocationManager.authorizationStatus())
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateLocationPermissions(_ :)), name: .didChangeLocationAuthorization, object: nil)
    }
    
    private func configureMap() {
        self.mapView.settings.myLocationButton = true
        self.mapView.settings.compassButton = true
        self.mapView.isMyLocationEnabled = true
        
    }
    
    private func configureUI(with status: CLAuthorizationStatus) {
        
        let shouldHideText: Bool
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            shouldHideText = true
        default:
            shouldHideText = false
        }
        
        self.disabledLocationView.isHidden = shouldHideText
    }
    
    @IBAction func didPressSettingsButton(_ sender: UIButton) {
        Router.show(destination: .settings)
    }
    
    @objc private func didUpdateLocationPermissions(_ notification: Notification) {
        guard let status = notification.object as? CLAuthorizationStatus else { return }
        configureUI(with: status)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
