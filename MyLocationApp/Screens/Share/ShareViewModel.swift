//
//  ShareViewModel.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/18/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import UIKit
import CoreData
import AlecrimCoreData

struct ShareViewModel {
    var location: LocationData?
    var contacts: [Contact] = []
    
    var placeButtonTitle: String {
        return self.location?.name ?? "Choose location..."
    }
    
    var contactsButtonTitle: String {
        return !self.contacts.isEmpty ? "Contacts selected ✅" :
                                        "Choose contacts..."
    }
    
    var shareButtonEnabled: Bool {
        return self.location != nil && !self.contacts.isEmpty
    }
    
    func didShareLocation() {
      saveSharedLocation()
    }
    
    private func saveSharedLocation() {
        guard let location = location,
              !contacts.isEmpty else { return }
        let context = CoreDataManager.shared.context
        
        context.share(location: location, with: contacts)
    }
}
