//
//  LocationTableViewCell.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/4/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import UIKit
import Reusable

class LocationTableViewCell: UITableViewCell, NibLoadable {

    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var detailsView: UIVisualEffectView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with location: LocationData) {
        
    }
    
}
