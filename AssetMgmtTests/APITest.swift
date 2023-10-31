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
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
