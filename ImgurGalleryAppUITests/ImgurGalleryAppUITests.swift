//
//  ImgurGalleryAppUITests.swift
//  ImgurGalleryAppUITests
//
//  Created by Rajashree Abhilash on 3/9/19.
//  Copyright © 2019 Rajashree Abhilash. All rights reserved.
//

import XCTest

class ImgurGalleryAppUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
    }

    func testImgurGalleryFilterText() {
        let filterText = app.staticTexts["Filter"]
        XCTAssertTrue(filterText.exists)
    }

}
