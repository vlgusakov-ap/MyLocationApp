//
//  Utilities.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/5/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import UIKit

class Utilities: NSObject
{
    //MARK: - App stuff
    static var appDisplayName: String?
    {
        return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
    }
    
    static var appBuild: String?
    {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }
    
    static var appVersion: String?
    {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    static var deviceOrientation: UIDeviceOrientation
    {
        return UIDevice.current.orientation
    }
    
    static var isPad: Bool
    {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isPhone: Bool
    {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    static var isRegisteredForRemoteNotifications: Bool
    {
        return UIApplication.shared.isRegisteredForRemoteNotifications
    }
    
    static var isRunningOnSimulator: Bool {
        // http://stackoverflow.com/questions/24869481/detect-if-app-is-being-built-for-device-or-simulator-in-swift
        #if (arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))
            return true
        #else
            return false
        #endif
    }
    
    
    //MARK: - View Controllers stuff
    private static func findTop(viewController: UIViewController) -> UIViewController
    {
        if let presentedVC = viewController.presentedViewController
        {
            return self.findTop(viewController: presentedVC)
        }
        else if let navViewController = viewController as? UINavigationController
        {
            guard let topNavVC = navViewController.topViewController else
            {
                return viewController
            }
            return self.findTop(viewController:topNavVC)
        }
        else if let tabBarViewController = viewController as? UITabBarController
        {
            guard let selectedVC = tabBarViewController.selectedViewController else
            {
                return viewController
            }
            return self.findTop(viewController:selectedVC)
        }
        
        return viewController
    }
    
    static var currentTopViewController: UIViewController?
    {
        guard let rootVC = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController else { return nil }
        return self.findTop(viewController: rootVC)
    }
}

