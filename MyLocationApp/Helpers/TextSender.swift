//
//  TextSender.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/19/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import Foundation
import MessageUI

class TextSender: NSObject {
    
    typealias TextSenderCompletion = (Result<Bool>) -> Void
    
    var completionHandler: TextSenderCompletion?
    
    func send(from viewController: UIViewController, message: TextMessage, completion: TextSenderCompletion?) {
        self.completionHandler = completion
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        composeVC.recipients = message.recipients
        composeVC.body = message.text
        viewController.present(composeVC, animated: true, completion: nil)
    }
}

extension TextSender: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        let res: Result<Bool>
        
        switch result {
        case .sent:
            res = .success(true)
        case .cancelled:
            res = .success(false)
        case .failed:
            let error = NSError.with(message: "The user’s attempt to send the message was unsuccessful.")
            res = .failure(error)
        }
        
        controller.dismiss(animated: true) {
            self.completionHandler?(res)
        }
    }
}
