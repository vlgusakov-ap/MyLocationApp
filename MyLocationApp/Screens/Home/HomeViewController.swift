//
//  HomeViewController.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/4/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import UIKit
import Reusable
import AlecrimCoreData

class HomeViewController: UIViewController {

    @IBOutlet weak var mapView: MapView!
    @IBOutlet weak var contactsButton: UIButton!
    @IBOutlet weak var shareButton: ShareButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard UserManager.shared.isLoggedIn else {
            Router.show(destination: .preAccount(destination: .main), presentationStyle: .modal)
            return
        }
        
        LocationManager.shared.getUserLocation()
    }
    
    private func configureNavBar() {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .always
        }
    }
    
    @IBAction func contactsButtonDidPress(_ sender: UIButton) {
        guard let contactsVC = self.storyboard?.instantiateViewController(withIdentifier: "contactsVC") as? ContactsTableViewController else { return }
        contactsVC.delegate = self
        self.navigationController?.pushViewController(contactsVC, animated: true)
    }
    
    @IBAction func shareButtonDidPress(_ sender: ShareButton) {
        guard let shareViewController = self.storyboard?.instantiateViewController(withIdentifier: "shareVC") as? ShareViewController else { return }
        let viewModel = ShareViewModel()
        shareViewController.viewModel = viewModel
        self.navigationController?.pushViewController(shareViewController, animated: true)
    }
    
    @IBAction func logOutDidPress(_ sender: Any) {
        UserManager.shared.logout()
    }
}

extension HomeViewController: ContactsTableViewControllerDelegate {
    func contactsTableViewController(_ contactsTableViewController: ContactsTableViewController, didTap contact: Contact) {
        let messagesVC = MessagesHistoryTableViewController()
        
        let context = CoreDataManager.shared.context
        context.performSync {
            let formattedNumber = PhoneNumberFormatter.phoneNumber(from: contact.phoneNumber)
            let contactData = context.contacts.firstOrCreated {
                $0.phoneNumber == formattedNumber
            }
            contactData.name = contact.name
            messagesVC.contact = contactData
        }
        self.navigationController?.pushViewController(messagesVC, animated: true)
    }
    
    func contactsTableViewController(_ contactsTableViewController: ContactsTableViewController, didSelectContacts contacts: [Contact]) {
        Logger.log(contacts)
    }
}
