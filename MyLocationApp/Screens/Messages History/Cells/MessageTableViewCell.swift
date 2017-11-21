//
//  MessageTableViewCell.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/21/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import UIKit
import Reusable

class MessageTableViewCell: UITableViewCell, NibLoadable {

    @IBOutlet private weak var locationAddressLabel: UILabel!
    @IBOutlet private weak var sentReceivedLabel: UILabel!
    
    private var place: PlaceData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(with place: PlaceData, isSent: Bool) {
        self.place = place
        
        self.locationAddressLabel.text = """
            \(place.name ?? "")
            \(place.address ?? "")
            """
        
        let sentReceived = isSent ? "Sent" : "Received"
        let date = Date(timeIntervalSince1970: TimeInterval(place.timestamp))
        self.sentReceivedLabel.text = "\(sentReceived) \(date.elapsedTime)"
    }
}
