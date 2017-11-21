//
//  PlaceDetailViewController.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/21/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import UIKit

class PlaceDetailViewController: UIViewController {

    @IBOutlet private weak var placeNameLabel: UILabel!
    @IBOutlet private weak var mapView: MapView!
    @IBOutlet private weak var placeAddressLabel: UILabel!
    @IBOutlet private weak var sharedLabel: UILabel!
    
    var place: PlaceData? {
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
        guard isViewLoaded, let place = place else { return }
        self.mapView.places = [place]
        
        self.placeNameLabel.text = place.name
        self.placeAddressLabel.text = place.address
        self.sharedLabel.text = "Shared to \(place.receivedFromContacts?.count ?? 0) users"
    }
}
