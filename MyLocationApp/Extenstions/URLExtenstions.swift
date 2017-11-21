//
//  URLExtenstions.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/6/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import Foundation

extension URL {
    
    enum URLParameter: String {
        case phoneNumber     = "pn"
        case placeId         = "pi"
    }
    
    //stashloc://?pi=123&pn=34790877
    init?(location: LocationData, contact: ContactData) {
        guard let phoneNumber = contact.phoneNumber else { return nil }
        let urlString = "stashloc://?\(URLParameter.placeId.rawValue)=\(location.placeId)&\(URLParameter.phoneNumber.rawValue)=\(phoneNumber)"
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        self = url
    }
    
    var deepLink: DeepLink? {
        guard let placeId = param(for: .placeId),
              let phoneNumber = param(for: .phoneNumber) else {
            return nil
        }
        
        return DeepLink(placeId: placeId, phoneNumber: phoneNumber)
    }
    
    func param(for key: URLParameter)->String? {

        guard let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true),
              let queryItems = urlComponents.queryItems else {
            return nil
        }
        
        let param = queryItems.filter { $0.name == key.rawValue }.first?.value
        
        return param
    }
}
