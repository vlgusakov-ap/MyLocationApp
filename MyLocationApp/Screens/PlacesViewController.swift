//
//  PlacesViewController.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/21/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import UIKit

class PlacesViewController: UIViewController {

    @IBOutlet private weak var mapView: MapView!
    
    var places: [PlaceData] = [] {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        updateUI()
    }
    
    private func configureUI() {
        self.mapView.mapView.settings.scrollGestures = false
    }
    
    private func updateUI() {
        guard isViewLoaded, !places.isEmpty else { return }
        self.mapView.places = places
    }
}
