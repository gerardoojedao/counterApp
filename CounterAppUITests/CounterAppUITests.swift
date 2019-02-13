//
//  CounterAppUITests.swift
//  CounterAppUITests
//
//  Created by Gerardo Ojeda on 11-02-19.
//  Copyright © 2019 Gerardo Ojeda. All rights reserved.
//

import XCTest

class CounterAppUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments += ["-AppleLanguages", "(en-US)"]
        app.launchArguments += ["-AppleLocale", "\"en-US\""]
        
        app.launch()

    }
    
    override func tearDown() {

        super.tearDown()
        
        app = nil
    }
    
    func testSetupUICorrectly() {
        
        self.exist(from: self, element: app.tables["table"])
        self.exist(from: self, element: app.navigationBars.buttons["Add"])
    }
    
    func testTapButtonAddCounter() {
        
        let buttonBar = app.navigationBars.buttons["Add"]
        self.exist(from: self, element: buttonBar)
        
        buttonBar.tap()
        
        let alert = app.alerts.buttons["Ok"]
        self.exist(from: self, element: alert)
    }
    
    func testTapButtonEdit() {
        
        let buttonEditBar = app.navigationBars.buttons["Edit"]
        self.exist(from: self, element: buttonEditBar)
        
        buttonEditBar.tap()
        
        let buttonAddBar = app.navigationBars.buttons["Add"]
        self.exist(from: self, element: buttonAddBar, time: 10, exist: false)
    }
    
    func testAddNewCounter() {
        
        let addButtonBar = app.navigationBars.buttons["Add"]
        self.exist(from: self, element: addButtonBar)
        
        addButtonBar.tap()
        
        let alert = app.alerts.buttons["Ok"]
        self.exist(from: self, element: alert)
            
        let textfield = app.alerts.textFields["textfieldNewCounter"]
        self.exist(from: self, element: textfield)
        
        textfield.tap()
        textfield.typeText("Counter Test")
        
        alert.tap()
        
        let editButtonBar = app.navigationBars.buttons["Edit"]
        self.exist(from: self, element: editButtonBar)
        
    }
    
    func testDeleteCounter() {
        
        let table = app.tables["table"]
        self.exist(from: self, element: table)
        
        let cell = table.cells.staticTexts["Counter Test"]
        self.exist(from: self, element: table)
        
        cell.swipeLeft()
        
        let deleteButtonCell = table.buttons["Delete"]
        self.exist(from: self, element: deleteButtonCell)
        
        deleteButtonCell.tap()
        
        let addButtonBar = app.navigationBars.buttons["Add"]
        self.exist(from: self, element: addButtonBar)
        
    }
    
    
    
    private func exist(from: XCTestCase, element: Any, time:TimeInterval = 15.0, exist: Bool = true) {
        
        let predicate = NSPredicate(format: "exists == \(exist)")
        from.expectation(for: predicate, evaluatedWith: element, handler: nil)
        from.waitForExpectations(timeout: time, handler: nil)
    }
}
