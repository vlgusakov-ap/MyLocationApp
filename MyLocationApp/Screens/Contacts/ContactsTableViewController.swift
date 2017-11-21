//
//  ContactsTableViewController.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/5/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import UIKit
import Reusable

protocol ContactsTableViewControllerDelegate: class {
    func contactsTableViewController(_ contactsTableViewController: ContactsTableViewController,
                                  didSelectContacts contacts: [Contact])
    func contactsTableViewController(_ contactsTableViewController: ContactsTableViewController,
                                     didTap contact: Contact)
}

class ContactsTableViewController: UITableViewController {

    enum Mode {
        case singleSelection
        case multiSelection
    }
    
    enum ViewState {
        case loading
        case empty
        case loaded(contacts: [Contact])
    }
    
    var mode: Mode = .singleSelection {
        didSet {
            switch mode {
            case .singleSelection:
                self.tableView.allowsMultipleSelection = false
            case .multiSelection:
                self.tableView.allowsMultipleSelection = true
            }
        }
    }
    
    var state: ViewState = .loading {
        didSet {
            self.tableView.reloadData()
            
            switch self.state {
            case .loading:
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            case .empty:
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            case .loaded(let contacts):
                self.navigationItem.rightBarButtonItem?.isEnabled = !contacts.isEmpty
            }
        }
    }
    
    weak var delegate: ContactsTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(cellType: UITableViewCell.self)
        self.tableView.register(cellType: SpinnerTableViewCell.self)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonPressed))
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchContacts()
    }
    
    @objc private func doneButtonPressed() {
        let selectedRows = self.tableView.indexPathsForSelectedRows ?? []
        if case .loaded(let contacts) = self.state {
            let selectedContacts = selectedRows.map { contacts[$0.row] }
            self.delegate?.contactsTableViewController(self, didSelectContacts: selectedContacts)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    private func fetchContacts() {
        ContactsManager.shared.contactsFromAddressBook { result in
            switch result {
            case .success(let contacts):
                self.state = .loaded(contacts: contacts)
            case .failure(let error):
                Utilities.currentTopViewController?.displayErrorAlert(error)
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch self.state {
        case .loading:
            return 1
        case .empty:
            return 0
        case .loaded(let contacts):
            return contacts.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch self.state {
        case .loading:
            let cell: SpinnerTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        case .empty:
            fatalError("Should never get called")
        case .loaded(let contacts):
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "shareCell", for: indexPath)
            let contact = contacts[indexPath.row]
            cell.textLabel?.text = contact.name
            cell.detailTextLabel?.text = contact.phoneNumber
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case .loaded(let contacts) = self.state else { return }
        
        let contact = contacts[indexPath.row]
        
        switch mode {
        case .multiSelection:
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        case .singleSelection:
            break
        }
        self.delegate?.contactsTableViewController(self, didTap: contact)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        switch self.state {
        case .loaded:
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        default:
            break
        }
    }
}
