//
//  AppDelegate.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/4/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import AlecrimCoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Given more time I would create a ServiceManager where I would put and manager services
        GMSServices.provideAPIKey("AIzaSyDUR9nZ27Q_Kfi0UdmKo-akCAIAOTRwM28")
        GMSPlacesClient.provideAPIKey("AIzaSyBJu0GzK12nXXQYz08C3zhVuBct8i6pvmI")
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.shared.saveContext()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if let deepLink = url.deepLink {
            let context = CoreDataManager.shared.context
            context.performSync {
                let place = context.places.firstOrCreated { $0.placeId == deepLink.placeId }
                Router.show(destination: .placeDetail(place))
                
                if place.timestamp == 0 {
                    place.timestamp = Int64(Date().timeIntervalSince1970)
                }
                let phoneNumber = PhoneNumberFormatter.phoneNumber(from: deepLink.phoneNumber)
                let contact = context.contacts.firstOrCreated { $0.phoneNumber == phoneNumber }
                contact.add(place: place, to: .sentPlaces)
            }
            
            return false
        }
        return true
    }

}

