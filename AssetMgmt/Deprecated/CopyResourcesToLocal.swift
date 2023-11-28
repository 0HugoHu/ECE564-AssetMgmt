//
//  CopyResourcesToLocal.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/2/23.
//

import Foundation

// Define the allowed file extensions
let allowedFileExtensions: Set<String> = ["pdf", "jpg"]


func copyFilesToPicturesDirectory() {
    let fileManager = FileManager.default
    
    if var sourceDirectoryURL = Bundle.main.url(forResource: "Sample", withExtension: "pdf") {
        sourceDirectoryURL.deleteLastPathComponent()
        let destinationDirectoryURL = URL.picturesDirectory
        
        do {
            try fileManager.createDirectory(at: destinationDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            logger.error("Error creating destination directory: \(error)")
            return
        }
        
        do {
            let sourceFiles = try fileManager.contentsOfDirectory(at: sourceDirectoryURL, includingPropertiesForKeys: nil, options: [])
            
            for sourceFileURL in sourceFiles {
                let fileExtension = sourceFileURL.pathExtension.lowercased()
                
                if allowedFileExtensions.contains(fileExtension) {
                    let fileName = sourceFileURL.lastPathComponent
                    let destinationFileURL = destinationDirectoryURL.appendingPathComponent(fileName)
                    
                    if !fileManager.fileExists(atPath: destinationFileURL.path) {
                        try fileManager.copyItem(at: sourceFileURL, to: destinationFileURL)
                        logger.info("File copied to .picturesDirectory: \(destinationFileURL.path)")
                    } else {
                        //                        logger.warning("File already exists in .picturesDirectory: \(destinationFileURL.path)")
                    }
                }
            }
        } catch {
            logger.error("Error copying files: \(error)")
        }
    } else {
        logger.error("Source directory not found in the app's bundle. Please check if you have changed file: Sample.pdf")
    }
}

