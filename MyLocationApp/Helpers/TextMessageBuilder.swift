//
//  TextMessageBuilder.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/19/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import Foundation
import CoreLocation

struct TextMessageBuilder {
    
    func shareTextMessage(location: LocationData, contacts: [Contact], deepLink: URL) -> TextMessage {
        
        let phoneNumbers = contacts.map { $0.phoneNumber }
        let text = """
            Hey! Check out my location
            \(location.name)
            \(location.address)\n\n
            \(deepLink.absoluteString)
            """
        let textMessage = TextMessage(text: text, recipients: phoneNumbers)
        return textMessage
    }
}
