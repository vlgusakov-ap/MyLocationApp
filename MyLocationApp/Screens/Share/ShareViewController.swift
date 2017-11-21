//
//  ShareViewController.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/5/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import AlecrimCoreData

class ShareViewController: UIViewController {

    //There is a known thread related warning described here https://stackoverflow.com/a/46478819
    @IBOutlet private weak var mapView: MapView!
    @IBOutlet private weak var chooseContactsButton: UIButton!
    @IBOutlet private weak var choosePlaceButton: UIButton!
    @IBOutlet private weak var shareButton: ShareButton!
    
    var viewModel: ShareViewModel? {
        didSet {
            guard self.isViewLoaded else { return }
            self.setupUI()
        }
    }
    
    lazy private var autocompleteViewController: GMSAutocompleteViewController = {
        let autocompleteViewController = GMSAutocompleteViewController()
        autocompleteViewController.delegate = self
        return autocompleteViewController
    }()
    
    var textSender: TextSender?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        guard let viewModel = self.viewModel else { return }
        self.choosePlaceButton.setTitle(viewModel.placeButtonTitle, for: .normal)
        self.chooseContactsButton.setTitle(viewModel.contactsButtonTitle, for: .normal)
        
        googleMapsDidChangePlace(locationData: viewModel.location)
        
        self.shareButton.isEnabled = viewModel.shareButtonEnabled
        
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    private func googleMapsDidChangePlace(locationData: LocationData?) {
        guard let locationData = locationData else { return }
        let place = CoreDataManager.shared.context.places.firstOrCreated { $0.placeId == locationData.placeId }
        place.populate(with: locationData)
        self.mapView.places = [place]
    }
    
    @IBAction func choosePlaceDidPress(_ sender: UIButton) {
        self.present(self.autocompleteViewController, animated: true, completion: nil)
    }
    
    @IBAction func chooseContactsDidPress(_ sender: UIButton) {
        guard let contactsVC = self.storyboard?.instantiateViewController(withIdentifier: "contactsVC") as? ContactsTableViewController else { return }
        contactsVC.delegate = self
        contactsVC.mode = .multiSelection
        self.navigationController?.pushViewController(contactsVC, animated: true)
    }
    
    @IBAction func shareButtonDidPress(_ sender: UIButton) {
        
        guard let viewModel = self.viewModel,
              let location = viewModel.location,
              !viewModel.contacts.isEmpty,
               let currentContact = CoreDataManager.shared.context.currentUserContact,
               let url = URL(location: location, contact: currentContact) else { return }
        
        // Configure the fields of the interface.
        self.textSender = TextSender()
        let textBuilder = TextMessageBuilder()
       
        let message = textBuilder.shareTextMessage(location: location, contacts: viewModel.contacts, deepLink: url)
        self.textSender?.send(from: self, message: message) { [weak self] (result) in
            guard let sself = self else { return }
            switch result {
            case .success(let isSent):
                if isSent {
                    sself.viewModel?.didShareLocation()
                    sself.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                Logger.log(error, type: .error)
            }
            sself.textSender = nil
        }
    }
}

extension ShareViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let location = LocationData(gmsPlace: place)
        self.viewModel?.location = location
        
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        Utilities.currentTopViewController?.displayErrorAlert(error)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

extension ShareViewController: ContactsTableViewControllerDelegate {
    
    func contactsTableViewController(_ contactsTableViewController: ContactsTableViewController, didTap contact: Contact) {
        
    }
    
    
    func contactsTableViewController(_ contactsTableViewController: ContactsTableViewController, didSelectContacts contacts: [Contact]) {
        self.viewModel?.contacts = contacts
    }
}
