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
 - noZip: Bool indicating whether to download as a zip file
 
 - Returns: Bool indicating success or failure
 */
func downloadFiles(to: URL, ids: [String], keepDirectoryStructure: Bool = false, noZip: Bool = false, completion: @escaping (Bool) -> Void) {
    var urlComponents = URLComponents(url: getDownloadURL(), resolvingAgainstBaseURL: false)
    
    var queryItems: [URLQueryItem] = []
    
    queryItems.append(URLQueryItem(name: "ids", value: ids.joined(separator: ",")))
    
    if keepDirectoryStructure {
        queryItems.append(URLQueryItem(name: "keepDirectoryStructure", value: "true"))
    }
    
    if noZip {
        queryItems.append(URLQueryItem(name: "noZip", value: "true"))
    }
    
    urlComponents?.queryItems = queryItems
    
    guard let finalURL = urlComponents?.url else {
        logger.error("Error constructing the download URL")
        completion(false)
        return
    }
    
    logger.info("Downloading files from \(finalURL.absoluteString)")
    
    download(from: finalURL, to: to) { success in
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
 
 - Returns: Array of AssetInfoResponse
 */
func searchSimple(search: String, directory: String, pageSize: Int = 100, pageIndex: Int = 0) -> [AssetInfoResponse]? { return nil }


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
//func searchAdvanced(searchObj: SearchModel, directory: String, pageSize: Int = 100, pageIndex: Int = 0, sortField: String?, sortDirection: String?, FILTERS: FilterModel?) -> [AssetInfoResponse]? { return nil }


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
