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
    let downloadTask = URLSession.shared.downloadTask(with: url) { tempURL, response, error in
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
                try FileManager.default.moveItem(at: tempURL, to: destinationURL)
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
