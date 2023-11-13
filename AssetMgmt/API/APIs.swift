//
//  APIs.swift
//  AssetMgmt
//
//  Created by Hugooooo on 10/29/23.
//

import Foundation
import SwiftUI

/*
 Get User Info
 
 - Returns: UserInfoAPIResponse
 */
func getUserInfo(completion: @escaping (UserInfoAPIResponse?) -> Void) {
    fetchData(from: getUserInfoURL(), responseType: UserInfoAPIResponse.self) { result in
        switch result {
        case .success(let userInfo):
            //            logger.info("Username: \(userInfo.username)")
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
func downloadFiles(to: URL, ids: [String], keepDirectoryStructure: Bool = false, progress: Binding<Int64>? = nil, completion: @escaping (Bool) -> Void) {
    guard var urlComponents = URLComponents(url: getDownloadURL(), resolvingAgainstBaseURL: false) else {
        logger.error("Error constructing the downloadFiles URL")
        return completion(false)
    }
    
    var existingQueryItems = urlComponents.queryItems ?? []
    
    existingQueryItems.append(URLQueryItem(name: "ids", value: "[" + ids.joined(separator: ",") + "]"))
    
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
    
    download(from: finalURL, to: to.appending(path: "/\(ids[0]).zip"), progress: progress, fileId: ids[0])
}



/*
 Upload Files
 
 - Parameters:
 - filePaths: Array of file paths to upload
 - dest: Destination directory
 
 - Returns: Bool indicating success or failure
 */
func uploadFiles(filePaths: [URL], dest: String, completion: @escaping (Bool) -> Void) {
    guard var urlComponents = URLComponents(url: getUploadURL(), resolvingAgainstBaseURL: false) else {
        logger.error("Error constructing the upload URL")
        return completion(false)
    }
    
    var existingQueryItems = urlComponents.queryItems ?? []
    
    let additionalQueryItems: [URLQueryItem] = [
        URLQueryItem(name: "dest", value: dest),
        URLQueryItem(name: "unzip", value: String(true)),
        URLQueryItem(name: "version", value: String(true))
    ]
    
    existingQueryItems.append(contentsOf: additionalQueryItems)
    
    urlComponents.queryItems = existingQueryItems
    
    guard let finalURL = urlComponents.url else {
        logger.error("Error constructing the final upload URL")
        return completion(false)
    }
    
    logger.info("Upload URL: \(finalURL)")
    
    upload(baseURL: finalURL.absoluteString, files: filePaths) { success in
        completion(success)
    }
}


/*
 Rename Files by Id
 
 - Parameters:
 - ids: File ids
 - newNames: New names for file
 
 - Returns: Bool indicating success or failure
 */
func renameFiles(ids: [Int], newNames: [String], completion: @escaping (Bool) -> Void) {
    guard var urlComponents = URLComponents(url: getRenameURL(), resolvingAgainstBaseURL: false) else {
        logger.error("Error constructing the rename URL")
        return completion(false)
    }
    
    var existingQueryItems = urlComponents.queryItems ?? []
    
    let idDictionaries = zip(ids, newNames).map { ["id": $0, "name": $1] }
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: idDictionaries, options: .prettyPrinted)
        
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            let additionalQueryItems: [URLQueryItem] = [
                URLQueryItem(name: "data", value: jsonString),
                URLQueryItem(name: "verbose", value: String(true))
            ]
            
            existingQueryItems.append(contentsOf: additionalQueryItems)
            
            urlComponents.queryItems = existingQueryItems
            
            guard let finalURL = urlComponents.url else {
                logger.error("Error constructing the final rename URL")
                return completion(false)
            }
            
            logger.info("Rename URL: \(finalURL)")
            
            fetchData(from: finalURL, responseType: [AssetInfoResponse].self) { result in
                switch result {
                case .success(let response):
                    if response.count == ids.count {
                        completion(true)
                    } else {
                        logger.error("Error renaming files: \(response)")
                        completion(false)
                    }
                case .failure(let error):
                    logger.error("Error renaming files: \(error)")
                    completion(false)
                }
            }
        }
    } catch {
        print("Error in renaming files, cannot convert data to JSON: \(error)")
    }
}


/*
 Rename Files by path
 
 - Parameters:
 - paths: File paths
 - newNames: New names for folder
 
 - Returns: Bool indicating success or failure
 */
func renameFiles(paths: [String], newNames: [String], completion: @escaping (Bool) -> Void) {
    guard var urlComponents = URLComponents(url: getRenameURL(), resolvingAgainstBaseURL: false) else {
        logger.error("Error constructing the rename URL")
        return completion(false)
    }
    
    var existingQueryItems = urlComponents.queryItems ?? []
    
    let idDictionaries = zip(paths, newNames).map { ["directory": $0, "name": $1] }
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: idDictionaries, options: .prettyPrinted)
        
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            let additionalQueryItems: [URLQueryItem] = [
                URLQueryItem(name: "data", value: jsonString),
                URLQueryItem(name: "verbose", value: String(true))
            ]
            
            existingQueryItems.append(contentsOf: additionalQueryItems)
            
            urlComponents.queryItems = existingQueryItems
            
            guard let finalURL = urlComponents.url else {
                logger.error("Error constructing the final rename URL")
                return completion(false)
            }
            
            logger.info("Rename URL: \(finalURL)")
            
            fetchData(from: finalURL, responseType: [DirectoryResponse].self) { result in
                switch result {
                case .success(let response):
                    if response.count == paths.count {
                        completion(true)
                    } else {
                        logger.error("Error renaming files: \(response)")
                        completion(false)
                    }
                case .failure(let error):
                    logger.error("Error renaming files: \(error)")
                    completion(false)
                }
            }
        }
    } catch {
        print("Error in renaming files, cannot convert data to JSON: \(error)")
    }
}


/*
 Delete Files by Ids
 
 - Parameters:
 - ids: Array of assets to delete
 
 - Returns: Bool indicating success or failure
 */
func deleteFiles(ids: [String], completion: @escaping (Bool) -> Void) {
    guard var urlComponents = URLComponents(url: getDeleteURL(), resolvingAgainstBaseURL: false) else {
        logger.error("Error constructing the delete URL")
        return completion(false)
    }
    
    var existingQueryItems = urlComponents.queryItems ?? []
    
    let idDictionaries = ids.map { ["id": $0] }
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: idDictionaries, options: .prettyPrinted)
        
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            let additionalQueryItems: [URLQueryItem] = [
                URLQueryItem(name: "data", value: jsonString),
                URLQueryItem(name: "verbose", value: String(true))
            ]
            
            existingQueryItems.append(contentsOf: additionalQueryItems)
            
            urlComponents.queryItems = existingQueryItems
            
            guard let finalURL = urlComponents.url else {
                logger.error("Error constructing the final delete URL")
                return completion(false)
            }
            
            logger.info("Delete URL: \(finalURL)")
            
            fetchData(from: finalURL, responseType: [AssetInfoResponse].self) { result in
                switch result {
                case .success(let response):
                    if response.count == ids.count {
                        completion(true)
                    } else {
                        logger.error("Error deleting files: \(response)")
                        completion(false)
                    }
                case .failure(let error):
                    logger.error("Error deleting files: \(error)")
                    completion(false)
                }
            }
        }
    } catch {
        print("Error in deleting files, cannot convert data to JSON: \(error)")
    }
}


/*
 Delete Files by paths
 
 - Parameters:
 - paths: Array of assets to delete
 
 - Returns: Bool indicating success or failure
 */
func deleteFiles(paths: [String], completion: @escaping (Bool) -> Void) {
    guard var urlComponents = URLComponents(url: getDeleteURL(), resolvingAgainstBaseURL: false) else {
        logger.error("Error constructing the delete URL")
        return completion(false)
    }
    
    var existingQueryItems = urlComponents.queryItems ?? []
    
    let idDictionaries = paths.map { ["path": $0] }
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: idDictionaries, options: .prettyPrinted)
        
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            let additionalQueryItems: [URLQueryItem] = [
                URLQueryItem(name: "data", value: jsonString),
                URLQueryItem(name: "verbose", value: String(true))
            ]
            
            existingQueryItems.append(contentsOf: additionalQueryItems)
            
            urlComponents.queryItems = existingQueryItems
            
            guard let finalURL = urlComponents.url else {
                logger.error("Error constructing the final delete URL")
                return completion(false)
            }
            
            logger.info("Delete URL: \(finalURL)")
            
            fetchData(from: finalURL, responseType: [DirectoryResponse].self) { result in
                switch result {
                case .success(let response):
                    if response.count == paths.count {
                        completion(true)
                    } else {
                        logger.error("Error deleting files: \(response)")
                        completion(false)
                    }
                case .failure(let error):
                    logger.error("Error deleting files: \(error)")
                    completion(false)
                }
            }
        }
    } catch {
        print("Error in deleting files, cannot convert data to JSON: \(error)")
    }
}


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
            completion(assetsInfo)
        case .failure(let error):
            logger.error("Error simple search: \(error)")
            completion(nil)
        }
    }
}


/*
 Simple Search with Details Response
 Used for file browser only
 
 - Parameters:
 - directory: Directory to search
 - pageSize: Number of results per page
 - pageIndex: Page index
 - verbose: Show details, can only be true
 
 - Returns: Array of Ids
 */
func simpleSearch(directory: String, verbose: Bool, pageSize: Int = 100, pageIndex: Int = 0, completion: @escaping ([AssetInfoResponse]?) -> Void) {
    guard var urlComponents = URLComponents(url: getSimpleSearchURL(), resolvingAgainstBaseURL: false) else {
        logger.error("Error constructing the search URL")
        return completion(nil)
    }
    
    var existingQueryItems = urlComponents.queryItems ?? []
    
    let additionalQueryItems: [URLQueryItem] = [
        URLQueryItem(name: "search", value: ""),
        URLQueryItem(name: "directory", value: directory),
        URLQueryItem(name: "pageSize", value: String(pageSize)),
        URLQueryItem(name: "pageIndex", value: String(pageIndex)),
        URLQueryItem(name: "verbose", value: String(verbose)),
    ]
    
    existingQueryItems.append(contentsOf: additionalQueryItems)
    
    urlComponents.queryItems = existingQueryItems
    
    guard let finalURL = urlComponents.url else {
        logger.error("Error constructing the final search URL")
        return completion(nil)
    }
    
    logger.info("Query URL: \(finalURL)")
    
    fetchData(from: finalURL, responseType: [AssetInfoResponse].self) { result in
        switch result {
        case .success(let assetsInfo):
            completion(assetsInfo)
        case .failure(let error):
            logger.error("Error simple search: \(error)")
            completion(nil)
        }
    }
}




/*
 Advanced Search
 Used for file browser only
 
 - Parameters:
 - search: JSON format of filters
 - directory: Directory to search
 - pageSize: Number of results per page
 - pageIndex: Page index
 
 - Returns: Array of AssetInfoResponse
 */
func advancedSearch(search: String, directory: String, verbose: Bool, pageSize: Int = 100, pageIndex: Int = 0, completion: @escaping ([AssetInfoResponse]?) -> Void) {
    guard var urlComponents = URLComponents(url: getAdvancedSearchURL(), resolvingAgainstBaseURL: false) else {
        logger.error("Error constructing the adv search URL")
        return completion(nil)
    }
    
    var existingQueryItems = urlComponents.queryItems ?? []
    
    let additionalQueryItems: [URLQueryItem] = [
        URLQueryItem(name: "search", value: search),
        URLQueryItem(name: "directory", value: directory),
        URLQueryItem(name: "pageSize", value: String(pageSize)),
        URLQueryItem(name: "pageIndex", value: String(pageIndex)),
        URLQueryItem(name: "verbose", value: String(verbose)),
    ]
    
    existingQueryItems.append(contentsOf: additionalQueryItems)
    
    urlComponents.queryItems = existingQueryItems
    
    guard let finalURL = urlComponents.url else {
        logger.error("Error constructing the final adv search URL")
        return completion(nil)
    }
    
    logger.info("Query URL: \(finalURL)")
    
    fetchData(from: finalURL, responseType: [AssetInfoResponse].self) { result in
        switch result {
        case .success(let assetsInfo):
            completion(assetsInfo)
        case .failure(let error):
            logger.error("Error adv search: \(error)")
            completion(nil)
        }
    }
}


/*
 Show Directory
 
 - Parameters:
 - path: Path to show
 - depth: Depth of directories to show
 - justChildren: Show just children folders
 
 - Returns: Array of AssetInfoResponse
 */
func showDirectory(path: String = "/", depth: Int = 0, justChildren: Bool = true, completion: @escaping ([DirectoryResponse]?) -> Void) {
    guard var urlComponents = URLComponents(url: getDirectoryURL(), resolvingAgainstBaseURL: false) else {
        logger.error("Error constructing the directory URL")
        return completion(nil)
    }
    
    var existingQueryItems = urlComponents.queryItems ?? []
    
    let additionalQueryItems: [URLQueryItem] = [
        URLQueryItem(name: "paths", value: path),
        URLQueryItem(name: "depth", value: String(depth)),
        URLQueryItem(name: "verbose", value: String(true)),
        URLQueryItem(name: "hierarchy", value: String(false)),
        URLQueryItem(name: "justChildren", value: String(justChildren))
    ]
    
    existingQueryItems.append(contentsOf: additionalQueryItems)
    
    urlComponents.queryItems = existingQueryItems
    
    guard let finalURL = urlComponents.url else {
        logger.error("Error constructing the final directory URL")
        return completion(nil)
    }
    
    logger.info("Directory URL: \(finalURL)")
    
    fetchData(from: finalURL, responseType: [DirectoryResponse].self) { result in
        switch result {
        case .success(let directories):
            completion(directories)
        case .failure(let error):
            logger.error("Error show directories: \(error)")
            completion(nil)
        }
    }
}


/*
 Create Directory
 
 - Parameters:
 - paths: Paths to create
 
 - Returns: Bool indicating success or failure
 */
func createDirectory(paths: [String], completion: @escaping ([DirectoryResponse]?) -> Void) {
    guard var urlComponents = URLComponents(url: getCreateURL(), resolvingAgainstBaseURL: false) else {
        logger.error("Error constructing the creation URL")
        return completion(nil)
    }
    
    var existingQueryItems = urlComponents.queryItems ?? []
    
    if let jsonData = try? JSONSerialization.data(withJSONObject: paths, options: .prettyPrinted) {
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            let additionalQueryItems: [URLQueryItem] = [
                URLQueryItem(name: "paths", value: jsonString),
                URLQueryItem(name: "verbose", value: String(true)),
            ]
            
            existingQueryItems.append(contentsOf: additionalQueryItems)
            
            urlComponents.queryItems = existingQueryItems
            
            guard let finalURL = urlComponents.url else {
                logger.error("Error constructing the final creation URL")
                return completion(nil)
            }
            
            logger.info("Creation URL: \(finalURL)")
            
            fetchData(from: finalURL, responseType: [DirectoryResponse].self) { result in
                switch result {
                case .success(let directories):
                    completion(directories)
                case .failure(let error):
                    logger.error("Error creating directories: \(error)")
                    completion(nil)
                }
            }
        }
    } else {
        print("Error converting array to JSON")
    }
}


/*
 Get Preview
 
 - Parameters:
 - id: File id
 
 - Returns: String containing preview URL
 */
func getPreview(id: String) -> String? { return nil }


/*
 Get Asset Details
 
 - Parameters:
 - ids: File ids
 
 - Returns: [AssetInfoResponse]?
 */
func getAssetDetails(ids: [String], completion: @escaping ([AssetInfoResponse]?) -> Void) {
    guard var urlComponents = URLComponents(url: getAssetInfoURL(), resolvingAgainstBaseURL: false) else {
        logger.error("Error constructing the asset info URL")
        return completion(nil)
    }
    
    var existingQueryItems = urlComponents.queryItems ?? []
    
    let additionalQueryItems: [URLQueryItem] = [
        URLQueryItem(name: "ids", value: "[" + ids.joined(separator: ",") + "]"),
        URLQueryItem(name: "verbose", value: String(true))
    ]
    
    existingQueryItems.append(contentsOf: additionalQueryItems)
    
    urlComponents.queryItems = existingQueryItems
    
    guard let finalURL = urlComponents.url else {
        logger.error("Error constructing the final asset info URL")
        return completion(nil)
    }
    
    logger.info("Asset info URL: \(finalURL)")
    
    fetchData(from: finalURL, responseType: [AssetInfoResponse].self) { result in
        switch result {
        case .success(let assetInfo):
            completion(assetInfo)
        case .failure(let error):
            logger.error("Error getting asset info: \(error)")
            completion(nil)
        }
    }
}
