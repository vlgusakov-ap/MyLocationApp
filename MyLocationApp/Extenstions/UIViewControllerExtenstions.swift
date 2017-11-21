//
//  UIViewControllerExtenstions.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/5/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import UIKit

extension UIViewController
{
    func displaySimpleAlertWith(title: String? = nil, message: String? = nil, actionTitle: String = "Ok", preferredStyle: UIAlertControllerStyle = .alert, hasCancelButton: Bool = false,  handler: ((UIAlertAction) -> Void)? = nil)
    {
        guard self.presentedViewController == nil else {
            Logger.log("Attempted to present an error on top of presented VC", type: .warning)
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let okAction = UIAlertAction(title: actionTitle, style: .default, handler: handler)
        
        alert.addAction(okAction)
        
        if hasCancelButton {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
        }
        alert.preferredAction = okAction
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayErrorAlert(_ error: Error?)
    {
        self.displayErrorAlert(error, title: nil)
    }
    
    func displayErrorAlert(_ error: Error?, title: String?)
    {
        guard let error = error else { return }
        let nsError = error as NSError
        guard nsError.code != -999 else { return } //Task canceled code
        
        let title = title ?? "Error"
        
        let message = (error as NSError).isDisplayable ? error.localizedDescription : "Oops! Something went wrong."
        self.displaySimpleAlertWith(title: title, message: message)
    }
}

