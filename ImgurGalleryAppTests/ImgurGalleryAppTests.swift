//
//  ImgurGalleryAppTests.swift
//  ImgurGalleryAppTests
//
//  Created by Rajashree Abhilash on 3/9/19.
//  Copyright © 2019 Rajashree Abhilash. All rights reserved.
//

import XCTest
@testable import ImgurGalleryApp

class ImgurGalleryAppTests: XCTestCase {
    var sut : URLSession!
    
    override func setUp() {
        super.setUp()
        sut = URLSession(configuration: .default)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testCallToImgurGalleryReturnsSuccess() {
        let url = URL(string: "https://api.imgur.com/3/gallery/top/top/week/0")!
        var request = URLRequest(url: url)
        request.setValue("Client-ID 1ffd23ef755faf4", forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        
        let promise = expectation(description: "Status code: 200")
        let dataTask = sut.dataTask(with: url) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                    XCTAssertEqual(statusCode, 200)
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
    }
    
    func testCallToImgurGallerySearchCompletes() {
        let url = URL(string: "https://api.imgur.com/3/gallery/search/top/week/0?q=Cats")!
        var request = URLRequest(url: url)
        request.setValue("Client-ID 1ffd23ef755faf4", forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        let dataTask = sut.dataTask(with: url) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
}

