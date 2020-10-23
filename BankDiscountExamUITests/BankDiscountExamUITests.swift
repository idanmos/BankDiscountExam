//
//  BankDiscountExamUITests.swift
//  BankDiscountExamUITests
//
//  Created by Idan Moshe on 22/10/2020.
//

import XCTest

class BankDiscountExamUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testCollectionViewDataSource() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: TravelCollectionViewController.self))
                
        guard let travelCollectionViewController = storyboard.instantiateViewController(withIdentifier: "TravelCollectionViewController") as? TravelCollectionViewController else {
            XCTFail("TravelCollectionViewController cannot be nil")
            return
        }
        
        travelCollectionViewController.loadView()
        
        let cell = travelCollectionViewController.collectionView.cellForItem(at: IndexPath(item: 0, section: 0))
        XCTAssertNil(cell, "UICollectionViewCell cannot be nil")
    }
    
}
