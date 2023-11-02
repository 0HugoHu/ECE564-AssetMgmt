//
//  APITest.swift
//  AssetMgmtTests
//
//  Created by Hugooooo on 10/31/23.
//

import XCTest
@testable import AssetMgmt

final class APITest: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // Important: You must first login before doing unit test
    func testGetUserInfo() throws {
        let expectation = XCTestExpectation(description: "getUserInfo completion called")
        
        getUserInfo { userInfo in
            XCTAssertNotNil(userInfo)
            expectation.fulfill()
        }
        
        // Actual time 0.37 s
        wait(for: [expectation], timeout: 1)
    }
    
    
    func testSimpleSearch() throws {
        let expectation = XCTestExpectation(description: "simpleSearch completion called")
        let searchText = "pdf"
        
        simpleSearch(search: searchText) { assetsInfo in
            XCTAssertNotNil(assetsInfo)
            logger.info("First result name: \(assetsInfo![0].id)")
            expectation.fulfill()
        }
        
        // Actual time 0.41 s
        wait(for: [expectation], timeout: 1)
    }
    
    
    func testDownloadFiles() throws {
        let expectation = XCTestExpectation(description: "downloadFiles completion called")
        let savePath = URL.documentsDirectory
        let testID = ["205596017"]
        
        downloadFiles(to: savePath, ids: testID) { success in
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        
        // Actual time 1.48 s
        wait(for: [expectation], timeout: 3)
    }
    
}
