//
//  LoginViewController.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/19/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import UIKit
import PhoneNumberKit

class LoginViewController: UIViewController {

    @IBOutlet weak var phoneNumberTextField: PhoneNumberTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.enableTapToDismissKeyboard()
        self.phoneNumberTextField.delegate = self
        self.phoneNumberTextField.returnKeyType = .done
    }

    @IBAction func didPressLogin(_ sender: UIButton) {
        let phoneNumber = PhoneNumberFormatter.phoneNumber(from: phoneNumberTextField.text ?? "")
        guard !phoneNumber.isEmpty else { return }

        let context = CoreDataManager.shared.context
        
        context.performSync {
            context.users.deleteAll()
            
            let user = context.users.create()
            user.phoneNumber = phoneNumber
            user.isLoggedIn = true
            
            let contact = context.contacts.create()
            contact.populate(with: user)
        }
                
        dismiss(animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.dismissKeyboard()
        return true
    }
}
