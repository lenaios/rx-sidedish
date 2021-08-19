//
//  RxSideDishUITests.swift
//  RxSideDishUITests
//
//  Created by Ador on 2021/07/28.
//

import XCTest

class RxSideDishUITests: XCTestCase {
  
  override func setUpWithError() throws {
    continueAfterFailure = false
  }
  
  func testExample() throws {
    let app = XCUIApplication()
    app.launch()
    
    let table = app.tables
    let cells = table.cells
    XCTAssertNotNil(cells.count)
    
    table.staticTexts["잡채"].tap()
    
    app.buttons["button.plus"].tap()
  }
  
  func testLaunchPerformance() throws {
    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
      measure(metrics: [XCTApplicationLaunchMetric()]) {
        XCUIApplication().launch()
      }
    }
  }
}
