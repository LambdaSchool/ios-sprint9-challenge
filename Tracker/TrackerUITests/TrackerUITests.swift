//
//  TrackerUITests.swift
//  TrackerUITests
//
//  Created by Nick Nguyen on 3/27/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import XCTest

class TrackerUITests: XCTestCase {

    private var app: XCUIApplication!
    
    private var rightBarButton: XCUIElement {
        return app.navigationBars.buttons["NavRightBarButtonItem"]
    }
    private var navTitle: XCUIElement {
        return app.navigationBars["Calorie Tracker"].staticTexts["Calorie Tracker"]
    }
    
    private var textField: XCUIElement {
        return app.alerts.textFields.firstMatch
    }
    
    private var submitButton: XCUIElement {
        return app.alerts.buttons["Submit"]
    }
    private var cell: XCUIElement {
        return app.cells["Cell"]
    }
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UITesting"]
        app.launch()
    }
    
    func testFirstLaunch() {
        XCTAssertTrue(navTitle.exists)
        XCTAssertTrue(rightBarButton.isHittable)
                
    }
    
    func testAddNewItem() {
        rightBarButton.tap()
        XCTAssertEqual(app.alerts.element.label, "Add Calorie Intake")
        textField.tap()
        textField.typeText("20022222")
        submitButton.tap()
        XCTAssertNotNil(app.tableRows.cells.count)
        XCTAssertTrue(cell.exists)
    }
    
   
}
