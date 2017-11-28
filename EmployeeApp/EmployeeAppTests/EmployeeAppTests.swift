//
//  EmployeeAppTests.swift
//  EmployeeAppTests
//
//  Created by Briahna Santillana on 10/5/17.
//  Copyright © 2017 Briahna Santillana. All rights reserved.
//

import XCTest
@testable import EmployeeApp

class EmployeeAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //MARK: Order Class Tests
    
    // Confirm that the Meal initializer returns a Meal object when passed valid parameters.
    func testOrderInitializationSucceeds() {
        
        // Order Number Zero ---- Test Fails
        let zeroOrderNumber = Order.init(orderNumber: 0, orderName: "Zero")
        XCTAssertNotNil(zeroOrderNumber)
        
        // Empty Name String ---- Test Fails
        let emptyStringName = Order.init(orderNumber: 10, orderName: "")
        XCTAssertNil(emptyStringName)
        
        // Order with the correct parameters ---- Test Passes
        let correctOrder = Order.init(orderNumber: 5, orderName: "Sam")
        XCTAssertNil(emptyStringName)
    }
    
}
