//
//  APIs.swift
//  AssetMgmt
//
//  Created by Hugooooo on 10/29/23.
//

import Foundation

/*
 Get User Info
 
 - Returns: UserInfoAPIResponse
 */
func getUserInfo(completion: @escaping (UserInfoAPIResponse?) -> Void) {
    fetchData(from: getUserInfoURL(), responseType: UserInfoAPIResponse.self) { result in
        switch result {
        case .success(let userInfo):
            logger.info("Username: \(userInfo.username)")
            completion(userInfo)
        case .failure(let error):
            logger.error("Error getting user info: \(error)")
            completion(nil)
        }
    }
}


/*
 Download Files
 
 - Parameters:
 - to: The position to save files
 - ids: Array of file ids to download
 - keepDirectoryStructure: Bool indicating whether to keep directory structure
 - noZip: [Deprecated] Bool indicating whether to download as a zip file
 
 - Returns: Bool indicating success or failure
 */
func downloadFiles(to: URL, ids: [String], keepDirectoryStructure: Bool = false, completion: @escaping (Bool) -> Void) {
    guard var urlComponents = URLComponents(url: getDownloadURL(), resolvingAgainstBaseURL: false) else {
        logger.error("Error constructing the downloadFiles URL")
        return completion(false)
    }
    
    var existingQueryItems = urlComponents.queryItems ?? []

    existingQueryItems.append(URLQueryItem(name: "ids", value: ids.joined(separator: ",")))
    
    if keepDirectoryStructure {
        existingQueryItems.append(URLQueryItem(name: "keepDirectoryStructure", value: "true"))
    }
    
//    if noZip {
//        existingQueryItems.append(URLQueryItem(name: "noZip", value: "true"))
//    }
    
    urlComponents.queryItems = existingQueryItems
    
    guard let finalURL = urlComponents.url else {
        logger.error("Error constructing the download URL")
        completion(false)
        return
    }
    
    logger.info("Downloading files from \(finalURL.absoluteString)")
    
    download(from: finalURL, to: to.appending(path: "/\(ids[0]).zip")) { success in
        completion(success)
    }
}



/*
 Upload Files
 
 - Parameters:
 - files: Array of files to upload
 - dest: Destination directory
 
 - Returns: Bool indicating success or failure
 */
func uploadFiles(files: [Data], dest: String) -> Bool { return true }


/*
 Rename File
 
 - Parameters:
 - data: AssetInfoResponse to rename
 - newName: New name for file
 
 - Returns: Bool indicating success or failure
 */
func renameFile(data: AssetInfoResponse, newName: String, completion: @escaping (Bool) -> Void) {
    var urlComponents = URLComponents(url: getRenameURL(), resolvingAgainstBaseURL: false)

    urlComponents?.queryItems = [
        URLQueryItem(name: "data", value: "[{\"id\":\(data.id),\"name\":\"\(newName)\"}]")
    ]

    guard let finalURL = urlComponents?.url else {
        logger.error("Error constructing the rename URL")
        completion(false)
        return
    }

    postRequest(to: finalURL) { success in
        completion(success)
    }
}


/*
 Delete Files
 
 - Parameters:
 - data: Array of AssetInfoResponse to delete
 
 - Returns: Bool indicating success or failure
 */
func deleteFiles(data: [AssetInfoResponse]) -> Bool { return true }


/*
 Simple Search
 
 - Parameters:
 - search: Search string
 - directory: Directory to search
 - pageSize: Number of results per page
 - pageIndex: Page index
 
 - Returns: Array of Ids
 */
func simpleSearch(search: String, directory: String = "/", pageSize: Int = 100, pageIndex: Int = 0, completion: @escaping ([SimpleIDResponse]?) -> Void) {
    guard var urlComponents = URLComponents(url: getSimpleSearchURL(), resolvingAgainstBaseURL: false) else {
        logger.error("Error constructing the search URL")
        return completion(nil)
    }

    var existingQueryItems = urlComponents.queryItems ?? []

    let additionalQueryItems: [URLQueryItem] = [
        URLQueryItem(name: "search", value: search),
        URLQueryItem(name: "directory", value: directory),
        URLQueryItem(name: "pageSize", value: String(pageSize)),
        URLQueryItem(name: "pageIndex", value: String(pageIndex))
    ]

    existingQueryItems.append(contentsOf: additionalQueryItems)

    urlComponents.queryItems = existingQueryItems

    guard let finalURL = urlComponents.url else {
        logger.error("Error constructing the final search URL")
        return completion(nil)
    }

    logger.info("Query URL: \(finalURL)")

    fetchData(from: finalURL, responseType: [SimpleIDResponse].self) { result in
        switch result {
        case .success(let assetsInfo):
            logger.info("Asset Count: \(assetsInfo.count)")
            completion(assetsInfo)
        case .failure(let error):
            logger.error("Error simple search: \(error)")
            completion(nil)
        }
    }
}




/*
 Advanced Search
 
 - Parameters:
 - searchObj: SearchObject
 - directory: Directory to search
 - pageSize: Number of results per page
 - pageIndex: Page index
 - sortField: Field to sort by
 - sortDirection: Direction to sort
 
 - Returns: Array of AssetInfoResponse
 */
//func advancedSearch(searchObj: SearchModel, directory: String, pageSize: Int = 100, pageIndex: Int = 0, sortField: String?, sortDirection: String?, FILTERS: FilterModel?) -> [AssetInfoResponse]? { return nil }


/*
 Show Directories
 
 - Parameters:
 - depth: Depth of directories to show
 - paths: Path to show
 
 - Returns: Array of AssetInfoResponse
 */
func showDirectories(depth: Int = 0, paths: String = "/") -> [AssetInfoResponse]? { return nil }


/*
 Create Directory
 
 - Parameters:
 - path: Path to create
 
 - Returns: Bool indicating success or failure
 */
func createDirectory(path: String) -> Bool { return true }


/*
 Get Preview
 
 - Parameters:
 - id: File id
 
 - Returns: String containing preview URL
 */
func getPreview(id: String) -> String? { return nil }


/*
 Get Details
 
 - Parameters:
 - id: File id
 
 - Returns: AssetInfoResponse
 */
func getDetails(id: String) -> AssetInfoResponse? { return nil }
