//
//  Download.swift
//  AssetMgmt
//
//  Created by Hugooooo on 10/31/23.
//

import Foundation


/*
 Download a file from a URL to a destination URL
 
 - Parameters:
 - url: The URL to download from
 - destinationURL: The URL to download to
 - completion: A closure that is called when the download is complete
 */
func download(from url: URL, to destinationURL: URL, completion: @escaping (Bool) -> Void) {
    let sessionConfiguration = URLSessionConfiguration.default
    let customDelegate = CustomURLDelegate()
    let session = URLSession(configuration: sessionConfiguration, delegate: customDelegate, delegateQueue: nil)
    
    let downloadTask = session.downloadTask(with: url) { tempURL, response, error in
        if let error = error {
            logger.error("Error downloading files: \(error)")
            completion(false)
            return
        }
        guard let tempURL = tempURL, let response = response as? HTTPURLResponse else {
            logger.error("Invalid response or temporary URL")
            completion(false)
            return
        }
        
        if response.statusCode == 200 {
            do {
//                var updatedDestinationURL = destinationURL
                
                // Append file type
//                if let contentType = response.allHeaderFields["Content-Type"] as? String {
//                    if let fileExtension = fileExtensionForContentType(contentType) {
//                        updatedDestinationURL.appendPathExtension(fileExtension)
//                    }
//                }
                
                // Check if a file with the same name already exists
                if FileManager.default.fileExists(atPath: destinationURL.path) {
                    let destinationWithUniqueName = generateUniqueDestinationURL(destinationURL)
                    try FileManager.default.moveItem(at: tempURL, to: destinationWithUniqueName)
                    try ZipUtility.unzipFile(from: destinationWithUniqueName, to: destinationWithUniqueName.deletingLastPathComponent())
                } else {
                    try FileManager.default.moveItem(at: tempURL, to: destinationURL)
                    try ZipUtility.unzipFile(from: destinationURL, to: destinationURL.deletingLastPathComponent())
                }
                
                completion(true)
            } catch {
                logger.error("Error saving the downloaded file: \(error)")
                completion(false)
            }
        } else {
            logger.error("Download request returned status code: \(response.statusCode)")
            completion(false)
        }
    }
    
    downloadTask.resume()
}
