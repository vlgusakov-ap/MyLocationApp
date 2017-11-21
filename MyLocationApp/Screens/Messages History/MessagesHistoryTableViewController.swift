//
//  MessagesHistoryTableViewController.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/21/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import UIKit
import Reusable

class MessagesHistoryTableViewController: UITableViewController {
    
    enum Mode {
        case singleSelection
        case multiSelection
    }
    
    var contact: ContactData? {
        didSet {
            self.title = contact?.name
            loadMessages()
        }
    }
    
    var places: [(PlaceData, Bool)] = [] {
        didSet {
            self.tableView.reloadData()
        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        self.tableView.register(cellType: MessageTableViewCell.self)
        self.tableView.estimatedRowHeight = 130
        
        let selectionButton = UIBarButtonItem(title: "Selection On/Off", style: .plain, target: self, action: #selector(triggerSelection))
        let detailsButton = UIBarButtonItem(title: "Details", style: .plain, target: self, action: #selector(openDetails))
        self.navigationItem.rightBarButtonItems = [detailsButton, selectionButton]
    }
    
    @objc private func triggerSelection() {
        switch mode {
        case .multiSelection:
            self.mode = .singleSelection
        case .singleSelection:
            self.mode = .multiSelection
        }
    }
    
    @objc private func openDetails() {
        guard case .multiSelection = mode else { return }
        
        let selectedIndexPaths = self.tableView.indexPathsForSelectedRows ?? []
        
        let places = selectedIndexPaths.map { self.places[$0.row].0 }
        
        Router.show(destination: .placesDetail(places))
    }
    
    private func loadMessages() {
        guard let contact = self.contact,
              let sentPlaces = contact.sentPlaces as? Set<PlaceData>,
              let receivedPlaces = contact.receivedPlaces as? Set<PlaceData> else { return }
        
        let sentPlacesTuple = sentPlaces.map { ($0, true) }
        let receivedPlacesTuple = receivedPlaces.map { ($0, false) }
        let places = sentPlacesTuple + receivedPlacesTuple
        
        let sortedPlaces = places.sorted { $0.0.timestamp < $1.0.timestamp }
        
        self.places = sortedPlaces
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessageTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let place = self.places[indexPath.row]
        cell.configure(with: place.0, isSent: place.1)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let place = self.places[indexPath.row].0
        
        switch mode {
        case .multiSelection:
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        case .singleSelection:
            Router.show(destination: .placeDetail(place))
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}
