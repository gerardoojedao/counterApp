//
//  CounterAppTests.swift
//  CounterAppTests
//
//  Created by Gerardo Ojeda on 11-02-19.
//  Copyright © 2019 Gerardo Ojeda. All rights reserved.
//

import XCTest
@testable import CounterApp

class CounterAppTests: XCTestCase {
    
    var window: UIWindow!
    var countersViewController: ListCounterViewController!
    
    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.
        countersViewController = ListCounterRouter.createModule() as! ListCounterViewController
        countersViewController.setupUI()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        self.countersViewController = nil

    }
    
    func testAddSimpleCounterSuccess() {
        
        let counter = Counter(id: "grer", title: "Counter 1", count: 3)
        
        countersViewController.updateUIWith([counter])
        
        XCTAssertEqual(countersViewController.countersArray.count, 1)
    }
    
    func testAddMultipleCountersSuccess() {
        
        let counterFirst = Counter(id: "grer", title: "Counter 1", count: 3)
        let counterSecond = Counter(id: "grewrer", title: "Counter 2", count: 6)
        let counterThird = Counter(id: "grgfser", title: "Counter 3", count: 8)
        
        countersViewController.updateUIWith([counterFirst, counterSecond, counterThird])
        
        let totalCounter = countersViewController.getTotalCounters()
        XCTAssertEqual(totalCounter, 17)
    }
    
    func testTotalSimpleCounter() {
        
        let counter = Counter(id: "grer", title: "Counter 1", count: 3)
        countersViewController.updateUIWith([counter])
        
        let totalCounter = countersViewController.getTotalCounters()
        XCTAssertEqual(totalCounter, 3)
    }
    
    func testTotalMultipleCounterCorrectSum() {
        
        let counterFirst = Counter(id: "grer", title: "Counter 1", count: 3)
        let counterSecond = Counter(id: "grewrer", title: "Counter 2", count: 6)
        let counterThird = Counter(id: "grgfser", title: "Counter 3", count: 8)
        
        countersViewController.updateUIWith([counterFirst, counterSecond, counterThird])
        
        let totalCounter = countersViewController.getTotalCounters()
        XCTAssertEqual(totalCounter, 17)
    }
    
    func testTotalMultipleCounterWrongSum() {
        
        let counterFirst = Counter(id: "grer", title: "Counter 1", count: 3)
        let counterSecond = Counter(id: "grewrer", title: "Counter 2", count: 6)
        let counterThird = Counter(id: "grgfser", title: "Counter 3", count: 8)
        
        countersViewController.updateUIWith([counterFirst, counterSecond, counterThird])
        
        let totalCounter = countersViewController.getTotalCounters()
        XCTAssertNotEqual(totalCounter, 20)
    }
    
    
}
