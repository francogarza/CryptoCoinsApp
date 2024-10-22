//
//  CoinListView_UITests.swift
//  CryptoCoinsUITests
//
//  Created by Franco Garza on 22/10/24.
//

import XCTest

final class CoinListViewUITests: XCTestCase {
    
    var app: XCUIApplication?
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app = XCUIApplication()
        
        guard let app else { return }
        
        app.launchEnvironment["QA_ENVIRONMENT"] = "true"
        
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func test_CoinListView_navigationToDetail_shouldPresentDetail() {
        // Given
        guard let app else { return }

        let coinListNavBarTitle = app.staticTexts["Crypto Coins"]
        XCTAssertTrue(coinListNavBarTitle.exists, "Expected to see Crypto Coins text but did not find it")
        
        // When
        let exists = app.scrollViews.otherElements.buttons["00, 1, Bitcoin, $1.37 T, $69,006.00, 5:39:18 p.m."].waitForExistence(timeout: 3)
        app.scrollViews.otherElements.buttons["00, 1, Bitcoin, $1.37 T, $69,006.00, 5:39:18 p.m."].tap()
        
        XCTAssertTrue(exists)
        
        // Then
        let navBarTitle = app.staticTexts["Coin Detail"]
        
        XCTAssertTrue(navBarTitle.exists, "Expected to see Coin Detail text but did not find it")
    }
    
    func test_CoinListView_navigationBackToHome_shouldReturn() {
        guard let app else { return }
        
        // Given
        let coinListNavBarTitle = app.staticTexts["Crypto Coins"]
        XCTAssertTrue(coinListNavBarTitle.exists, "Expected to see Crypto Coins text but did not find it")
        
        // When
        let exists = app.scrollViews.otherElements.buttons["00, 1, Bitcoin, $1.37 T, $69,006.00, 5:39:18 p.m."].waitForExistence(timeout: 3)
        app.scrollViews.otherElements.buttons["00, 1, Bitcoin, $1.37 T, $69,006.00, 5:39:18 p.m."].tap()
        
        XCTAssertTrue(exists)
        
        // Then
        let navBarTitle = app.staticTexts["Coin Detail"]
        
        XCTAssertTrue(navBarTitle.exists, "Expected to see Coin Detail text but did not find it")
        
        app.buttons["Back"].tap()
        let coinListsViewTitleExists = app.staticTexts["Crypto Coins"].exists
        
        XCTAssertTrue(coinListsViewTitleExists, "Expected to see Coin List Title text but did not find it")
    }
}
