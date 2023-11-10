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
    
    
    func testAdvancedSearch() throws {
        let expectation = XCTestExpectation(description: "advancedSearch completion called")
        let searchText = SearchFilter.createSearchCriteria(conjunction: .and, fieldId: "directory_id", condition: SearchFilter.OtherField.equals, value: "204788")
        
        advancedSearch(search: searchText, directory: "/", verbose: true) { assetsInfo in
            XCTAssertNotNil(assetsInfo)
            logger.info("First result name: \(assetsInfo![0].id)")
            expectation.fulfill()
        }
        
        // Actual time 0.53 s
        wait(for: [expectation], timeout: 1)
    }
    
    
    func testDownloadFiles() throws {
        let expectation = XCTestExpectation(description: "downloadFiles completion called")
        let savePath = URL.documentsDirectory
        let testID = ["205596017", "205602533"]
        
        downloadFiles(to: savePath, ids: testID) { success in
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        
        // Actual time 1.85 s
        wait(for: [expectation], timeout: 3)
    }
    
    func testUploadFiles() throws {
        let expectation = XCTestExpectation(description: "uploadFiles completion called")
        let uploadPath = "/"
        let picturesDirectoryURL = URL.picturesDirectory
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: picturesDirectoryURL, includingPropertiesForKeys: nil, options: [])
            
            uploadFiles(filePaths: fileURLs, dest: uploadPath) { success in
                XCTAssertTrue(success)
                expectation.fulfill()
            }
        } catch {
            XCTFail("Error enumerating .picturesDirectory: \(error)")
        }
        
        // Actual time 6 s
        wait(for: [expectation], timeout: 10)
    }
    
    func testAssetInfo() throws {
        let expectation = XCTestExpectation(description: "assetInfo completion called")
        let testIDs = ["205596017", "205602533"]
        
        getAssetDetails(ids: testIDs) { assetInfo in
            XCTAssertNotNil(assetInfo)
            logger.info("Asset: \(assetInfo![0].name), \(assetInfo![0].path), \(assetInfo![0].bytes)")
            expectation.fulfill()
        }
        
        // Actual time 0.42 s
        wait(for: [expectation], timeout: 1)
    }
    
    
    func testShowDirectory() throws {
        let expectation = XCTestExpectation(description: "showDirectory completion called")
        let testPath = "/"
        let depth = 1
        
        showDirectory(path: testPath, depth: depth) { directories in
            XCTAssertNotNil(directories)
            for folder in directories! {
                logger.info("Asset: \(folder.name), \(folder.path), \(folder.id), \(String(describing: folder.hasChildren))")
            }
            expectation.fulfill()
        }
        
        // Actual time 0.41 s
        wait(for: [expectation], timeout: 1)
    }

    
}
