//
//  MyLocationAppTests.swift
//  MyLocationAppTests
//
//  Created by Vladyslav Gusakov on 11/4/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import XCTest
@testable import MyLocationApp

class MyLocationAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testValidDeeplink() {
        let url = URL(string: "stashloc://?pi=aDfdfaf+dasdasd&pn=+13479683047")
        
        let deepLink = url?.deepLink
        XCTAssertNotNil(deepLink)
    }
    
    func testValidDeeplinkParams() {
        let url = URL(string: "stashloc://?pi=aDfdfaf+dasdasd&pn=+13479683047")
        let phoneNumber = url?.param(for: .phoneNumber)
        let placeId = url?.param(for: .placeId)
        
        XCTAssertNotNil(phoneNumber)
        XCTAssertNotNil(placeId)
    }
    
    func testInvalidDeeplink() {
        let url = URL(string: "stashloc://pi=aDfdfaf+dasdasd&pn=+13479683047")
        
        let deepLink = url?.deepLink
        XCTAssertNil(deepLink)
    }
    
    func testInvalidParams() {
        let url = URL(string: "stashloc://?pid=aDfdfaf+dasdasd&phn=+13479683047")
        let phoneNumber = url?.param(for: .phoneNumber)
        let placeId = url?.param(for: .placeId)
        
        XCTAssertNil(phoneNumber)
        XCTAssertNil(placeId)
    }
    
    func testPerformanceExample() {
        self.measure {
        }
    }
    
}
