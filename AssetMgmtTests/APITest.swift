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
        
        wait(for: [expectation], timeout: 3)
        
    }
    
    func testDownloadFiles() throws {
        let expectation = XCTestExpectation(description: "downloadFiles completion called")
        let savePath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("testDownloadFiles")
        let testID = ["205596017"]
        
        downloadFiles(to: savePath, ids: testID) { success in
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
}
