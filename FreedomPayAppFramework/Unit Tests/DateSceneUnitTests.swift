//
//  DateSceneUnitTests.swift
//  FreedomPay
//
//  Created by Michael on 12/20/17.
//  Copyright © 2017 Michael. All rights reserved.
//

import XCTest
@testable import FreedomPayAppFramework

class DateSceneUnitTests: XCTestCase {
    
    let interactor = DateViewControllerLogic()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testVaidDateisValid() {
        let validDate = DateStruct(month: 6, year: 2020)
        interactor.currentDate = validDate
        let result = interactor.isValid()
        switch result {
        case .success(_):
            XCTAssert(true)
        default:
            XCTFail("A valid date is invalid")
        }
    }
    
    func testCurrentDateisValid() {
        let validDate = DateStruct(month: CalendarData.currentMonth.rawValue, year: CalendarData.currentYear)
        interactor.currentDate = validDate
        let result = interactor.isValid()
        switch result {
        case .success(_):
            XCTAssert(true)
        default:
            XCTFail("The current date should be vaild")
        }
    }
    
    func testInvalidDateIsInvalid() {
        let invalidDate = DateStruct(month: 7, year: 2017)
        interactor.currentDate = invalidDate
        let result = interactor.isValid()
        switch result {
        case .error(_):
            XCTAssert(true)
        default:
            XCTFail("A date which occurs in the past did not result in error.")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
