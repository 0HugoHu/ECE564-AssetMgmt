//
//  Unzip.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/2/23.
//

import Foundation
import Zip

class ZipUtility {
    static func unzipFile(from sourceURL: URL, to destinationURL: URL) throws {
        do {
            let unzipDirectory = try Zip.quickUnzipFile(sourceURL)
            let fileManager = FileManager.default
            let contents = try fileManager.contentsOfDirectory(at: unzipDirectory, includingPropertiesForKeys: nil, options: [])
            
            for item in contents {
                let destinationItemURL = destinationURL.appendingPathComponent(item.lastPathComponent)
                if FileManager.default.fileExists(atPath: destinationItemURL.path) {
                    let destinationWithUniqueName = generateUniqueDestinationURL(destinationItemURL)
                    try fileManager.moveItem(at: item, to: destinationWithUniqueName)
                } else {
                    try fileManager.moveItem(at: item, to: destinationItemURL)
                }
            }
            
            try fileManager.removeItem(at: unzipDirectory)
            try fileManager.removeItem(at: sourceURL)
        } catch {
            throw UnzipError.unzipFailed
        }
    }
    
    static func zipFiles(_ sourceURLs: [URL], fileName: String, destinationURL: URL) throws -> URL {
        do {
            let zipFilePath = try Zip.quickZipFiles(sourceURLs, fileName: fileName)
            try FileManager.default.moveItem(at: zipFilePath, to: destinationURL)
            return destinationURL
        } catch {
            throw ZipError.zipFailed
        }
    }
}

enum UnzipError: Error {
    case unzipFailed
}

enum ZipError: Error {
    case zipFailed
}

