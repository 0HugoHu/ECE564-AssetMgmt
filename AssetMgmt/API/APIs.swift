//
//  APIs.swift
//  AssetMgmt
//
//  Created by Hugooooo on 10/29/23.
//

import Foundation


/*
 Get User Info
 
 - Returns: Bool indicating success or failure
 */

func getUserInfo() -> Bool { return true }


/*
 Get API Key
 
 - Parameters:
    - ids: Array of file ids to download
    - keepDirectoryStructure: Bool indicating whether to keep directory structure
    - noZip: Bool indicating whether to download as a zip file
 
 - Returns: Bool indicating success or failure
 */
func downloadFiles(ids: [String], keepDirectoryStructure: Bool = false, noZip: Bool = false) -> Bool { return true }


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
    - data: CustomFileModel to rename
    - newName: New name for file
 
 - Returns: Bool indicating success or failure
 */
func renameFile(data: CustomFileModel, newName: String) -> Bool { return true }


/*
 Delete Files
 
 - Parameters:
    - data: Array of CustomFileModel to delete
 
 - Returns: Bool indicating success or failure
 */
func deleteFiles(data: [CustomFileModel]) -> Bool { return true }


/*
 Simple Search
 
 - Parameters:
    - search: Search string
    - directory: Directory to search
    - pageSize: Number of results per page
    - pageIndex: Page index
 
 - Returns: Array of CustomFileModel
 */
func searchSimple(search: String, directory: String, pageSize: Int = 100, pageIndex: Int = 0) -> [CustomFileModel]? { return nil }


/*
 Advanced Search
 
 - Parameters:
    - searchObj: SearchObject
    - directory: Directory to search
    - pageSize: Number of results per page
    - pageIndex: Page index
    - sortField: Field to sort by
    - sortDirection: Direction to sort
 
 - Returns: Array of CustomFileModel
 */
func searchAdvanced(searchObj: SearchModel, directory: String, pageSize: Int = 100, pageIndex: Int = 0, sortField: String?, sortDirection: String?, FILTERS: FilterModel?) -> [CustomFileModel]? { return nil }


/*
 Show Directories
 
 - Parameters:
    - depth: Depth of directories to show
    - paths: Path to show
 
 - Returns: Array of CustomFileModel
 */
func showDirectories(depth: Int = 0, paths: String = "/") -> [CustomFileModel]? { return nil }


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
 
 - Returns: CustomFileModel
 */
func getDetails(id: String) -> CustomFileModel? { return nil }
