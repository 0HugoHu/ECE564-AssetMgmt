//
//  CustomUrlDelegate.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/2/23.
//

import Foundation
import SwiftUI

/*
 Custom URL Delegate
 
 - Returns: URLSessionDelegate
 */
class CustomURLDelegate: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
    var progress: Binding<Int64>?
    var destinationURL: URL
    var fileId: String
    
    init(progress: Binding<Int64>?, destinationURL: URL, fileId: String) {
        self.progress = progress
        self.destinationURL = destinationURL
        self.fileId = fileId
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            // Accept the trust without validation
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if progress != nil {
            progress!.wrappedValue = totalBytesWritten
        }
        UserDefaults.standard.setValue(totalBytesWritten, forKey: "download@\(fileId)")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        logger.info("Download finish: \(location)")
        if let error = downloadTask.error {
            logger.error("Error downloading files: \(error)")
            return
        }
        let tempURL = location
        guard let response = downloadTask.response as? HTTPURLResponse else {
            logger.error("Invalid response or temporary URL")
            return
        }
        if response.statusCode == 200 {
            do {
                let destinationWithUniqueName = generateUniqueDestinationURL(destinationURL)
                try FileManager.default.moveItem(at: tempURL, to: destinationWithUniqueName)
                try ZipUtility.unzipFile(from: destinationWithUniqueName, to: destinationWithUniqueName.deletingLastPathComponent())
                UserDefaults.standard.setValue(-1, forKey: "download@\(fileId)")
                if progress != nil {
                    progress!.wrappedValue = -1
                }
            } catch {
                logger.error("Error saving the downloaded file: \(error)")
            }
        } else {
            logger.error("Download request returned status code: \(response.statusCode)")
        }
    }
    
}
