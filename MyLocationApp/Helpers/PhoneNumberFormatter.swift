//
//  PhoneNumberFormatter.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/19/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import Foundation
import PhoneNumberKit

struct PhoneNumberFormatter {
    
    static func phoneNumber(from unformattedPhoneNumber: String) -> String {
        let phoneNumberKit = PhoneNumberKit()
        guard let phoneNumber = try? phoneNumberKit.parse(unformattedPhoneNumber) else { return "" }
        let formattedNumber = phoneNumberKit.format(phoneNumber, toType: .e164) // +61236618300
        return formattedNumber ?? ""
    }
    
}
