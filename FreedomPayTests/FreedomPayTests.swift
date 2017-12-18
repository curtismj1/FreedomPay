//
//  FreedomPayTests.swift
//  FreedomPayTests
//
//  Created by Michael on 12/16/17.
//  Copyright © 2017 Michael. All rights reserved.
//

import XCTest
@testable import FreedomPay

enum Month: Int {
    case January = 1
    case February = 2
    case March = 3
    case April = 4
    case May = 5
    case June = 6
    case July = 7
    case August = 8
    case September = 9
    case October = 10
    case November = 11
    case December = 12
}

class CalendarData {
    
    static var currentYear: Int {
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.year, from: date)
    }
    
    static var currentMonth: Month {
        let date = Date()
        let calendar = Calendar.current
        return Month(rawValue: calendar.component(.month, from: date))!
    }
}
let cm = CalendarData.currentMonth


class FreedomPayTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let cm = CalendarData.currentMonth
        XCTAssert(cm.rawValue == 12)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
