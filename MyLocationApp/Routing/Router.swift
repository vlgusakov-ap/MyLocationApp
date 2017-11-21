//
//  Router.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/4/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import UIKit
import DeckTransition

enum DestinationPresentationStyle {
    case push
    case modal
}

class Router: NSObject
{
    //MARK: - Public
    static func show(destination: Destination, presentationStyle: DestinationPresentationStyle = .push, animated: Bool = true) {
        switch destination {
        case .home:
            //TODO: Not implemented
            break
        case .preAccount(let destination):
            self.show(destination: destination, presentationStyle: presentationStyle, animated: animated)
        case .settings:
            openSettings()
        }
    }
    
    static func show(destination: Destination.HomeDestination, presentationStyle: DestinationPresentationStyle = .push, animated: Bool = true) {
        
        switch destination {
        case .placesDetail(let places):
            let placesVC = UIStoryboard.main.instantiateViewController(withIdentifier: "placesVC") as! PlacesViewController
            let transitioningDelegate = DeckTransitioningDelegate()
            placesVC.transitioningDelegate = transitioningDelegate
            placesVC.modalPresentationStyle = .custom
            placesVC.places = places
            Utilities.currentTopViewController?.present(placesVC, animated: true, completion: nil)
        case .placeDetail(let place):
            let placeVC = UIStoryboard.main.instantiateViewController(withIdentifier: "placeVC") as! PlaceDetailViewController
            let transitioningDelegate = DeckTransitioningDelegate()
            placeVC.transitioningDelegate = transitioningDelegate
            placeVC.modalPresentationStyle = .custom
            placeVC.place = place
            Utilities.currentTopViewController?.present(placeVC, animated: true, completion: nil)
        case .main:
            break
        }
    }
    
    static func show(destination: Destination.PreAccountDestination, presentationStyle: DestinationPresentationStyle = .push, animated: Bool = true) {
        let loginVC = UIStoryboard.main.instantiateViewController(withIdentifier: "loginVC")
        self.present(viewController: loginVC, presentationStyle: presentationStyle, animated: animated)
    }
    
    //MARK: - Private
    static private func present(viewController: UIViewController, presentationStyle: DestinationPresentationStyle, animated: Bool) {
        let currentViewController = Utilities.currentTopViewController
        let viewControllerToPresent: UIViewController
        
        switch presentationStyle {
        case .push:
            
            if currentViewController?.navigationController != nil {
                viewControllerToPresent = viewController
            }
            else {
                viewControllerToPresent = UINavigationController(rootViewController: viewController)
            }
            currentViewController?.navigationController?.pushViewController(viewControllerToPresent, animated: animated)
        case .modal:
            guard currentViewController?.presentedViewController == nil else {
                Logger.log("Cannot present two modal view controllers from the same view controller", type: .warning)
                return
            }
            viewControllerToPresent = UINavigationController(rootViewController: viewController)
            currentViewController?.present(viewControllerToPresent, animated: animated, completion: nil)
        }
    }
    
    private static func openSettings() {
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else { return }
        UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
    }
}

