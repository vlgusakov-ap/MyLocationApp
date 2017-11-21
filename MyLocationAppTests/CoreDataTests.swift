//
//  CoreDataTests.swift
//  MyLocationAppTests
//
//  Created by Vladyslav Gusakov on 11/21/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import XCTest
import CoreData
import AlecrimCoreData
import CoreLocation

@testable import MyLocationApp

class CoreDataTests: XCTestCase {
    
    //Ideally, create an in memory context that can be tested w/o changing the main one
    let context = CoreDataManager.shared.context
    
    var testContact: Contact {
        return Contact(name: "Vlad", phoneNumber: "+13479683047")
    }
    
    var testPlace: LocationData {
        let location = CLLocationCoordinate2D(latitude: -40.13242424, longitude: 70.2323566)
        return LocationData(name: "Stash Invest", coordinate: location, address: "123 York st", placeId: "Qzdsdsd+sdsg1356")
    }
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testContactCanBeSaved() {
        let count = context.contacts.count()
        
        context.performSync {
            let contact = context.contacts.create()
            contact.populate(with: testContact)
        }
        
        XCTAssert(context.contacts.count() == count+1)
    }
    
    func testPlaceCanBeSaved() {
        let count = context.places.count()
        
        context.performSync {
            let place = context.places.create()
            place.populate(with: testPlace)
        }
        
        XCTAssert(context.places.count() == count+1)
    }
    
    func testContactSentPlaces() {
        let newContact = context.contacts.create()
        let newPlace = context.places.create()
        context.performSync {
            newContact.populate(with: testContact)
            newPlace.populate(with: testPlace)
            newContact.add(place: newPlace, to: .sentPlaces)
        }
        
        XCTAssert(newContact.sentPlaces?.count == 1)
        XCTAssert(newPlace.receivedFromContacts?.count == 1)
    }
}
