//
//  GenerateUniqueUrl.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/2/23.
//

import Foundation

/*
 Generate a unique URL for the destination file
 
 - Parameters:
    - destinationURL: The URL to download to
 
 - Returns: A unique URL for the destination file
 */
func generateUniqueDestinationURL(_ destinationURL: URL) -> URL {
    var destinationURL = destinationURL
    var counter = 1
    let fileExtension = destinationURL.pathExtension
    let baseURL = destinationURL.deletingPathExtension()

    while FileManager.default.fileExists(atPath: destinationURL.path) {
        let uniqueFileName = baseURL.appendingPathExtension("(\(counter))")
        destinationURL = uniqueFileName.appendingPathExtension(fileExtension)
        counter += 1
    }

    return destinationURL
}
