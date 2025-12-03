//
// Infinion_AssementUITests.swift
// Infinion-AssementUITests
//
// Created by Omidiora on 03/12/2025.
//

import XCTest

final class Infinion_AssementUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        
        app.launchArguments = ["-resetUserDefaults"]
        app.launch()
        
        Thread.sleep(forTimeInterval: 2.5)
    }

    override func tearDownWithError() throws {
        app.terminate()
        app = nil
    }

    func testFullUserJourney_Search_SaveFavorite_VerifyPersistence() throws {
        let app = self.app
        
        XCTAssertTrue(app.textFields["Search city..."].exists)
        
        let searchField = app.textFields["Search city..."]
        searchField.tap()
        searchField.typeText("Lagos")
        
        let searchButton = app.buttons["Search Weather"]
        XCTAssertTrue(searchButton.exists)
        searchButton.tap()
        
        let cityNameLabel = app.staticTexts["Lagos"]
        XCTAssertTrue(cityNameLabel.waitForExistence(timeout: 10))
        
        let saveButton = app.buttons["Save as Favorite"]
        XCTAssertTrue(saveButton.exists)
        saveButton.tap()
        
        let savedText = app.staticTexts["Saved as favorite!"]
        XCTAssertTrue(savedText.waitForExistence(timeout: 5))
        
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        app.terminate()
        app.launch()
        Thread.sleep(forTimeInterval: 2.5)
        
        XCTAssertTrue(app.staticTexts["Your Favorite"].exists)
        XCTAssertTrue(app.staticTexts["Lagos"].exists)
        
        XCTAssertEqual(searchField.value as? String, "Lagos")
        
        XCTAssertTrue(app.staticTexts["Lagos"].exists)
    }
    
    func testSearchHistory_IsSaved_And_Clickable() throws {
        let app = self.app
        
        let searchField = app.textFields["Search city..."]
        searchField.tap()
        searchField.typeText("Paris\n")
        
        XCTAssertTrue(app.staticTexts["Paris"].waitForExistence(timeout: 10))
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        searchField.tap()
        searchField.typeText("Tokyo\n")
        XCTAssertTrue(app.staticTexts["Tokyo"].waitForExistence(timeout: 10))
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        let recentSection = app.staticTexts["Recent Searches"]
        XCTAssertTrue(recentSection.exists)
        
        XCTAssertTrue(app.buttons.containing(.staticText, identifier:"Tokyo").firstMatch.exists)
        XCTAssertTrue(app.buttons.containing(.staticText, identifier:"Paris").firstMatch.exists)
        
        app.buttons.containing(.staticText, identifier:"Paris").firstMatch.tap()
        XCTAssertTrue(app.staticTexts["Paris"].waitForExistence(timeout: 8))
    }
    
    func testFavoriteCityCard_IsClickable_And_RefreshesWeather() throws {
        let app = self.app
        
        let searchField = app.textFields["Search city..."]
        searchField.tap()
        searchField.typeText("London\n")
        
        XCTAssertTrue(app.staticTexts["London"].waitForExistence(timeout: 10))
        app.buttons["Save as Favorite"].tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        app.terminate()
        app.launch()
        Thread.sleep(forTimeInterval: 2.5)
        
        let favoriteButton = app.buttons.containing(.staticText, identifier:"London").firstMatch
        XCTAssertTrue(favoriteButton.exists)
        favoriteButton.tap()
        
        XCTAssertTrue(app.staticTexts["London"].waitForExistence(timeout: 10))
    }
    
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}