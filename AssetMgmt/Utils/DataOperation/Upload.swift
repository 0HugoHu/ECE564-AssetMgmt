//
//  Upload.swift
//  AssetMgmt
//
//  Created by Hugooooo on 10/31/23.
//

import Foundation
import Alamofire
import SwiftUI


/*
 Upload files from the URLs to a destination directory on cloud
 
 - Parameters:
 - baseURL: The base URL of the server
 - files: The URLs of the files to upload
 */
func upload(baseURL: String, files: [URL], uploadProgress: Binding<Double>? = nil, completion: @escaping (Bool) -> Void) {
    do {
        let zipURL = try ZipUtility.zipFiles(files, fileName: "tmp.zip", destinationURL: .temporaryDirectory)
        
        logger.info("Upload start, from \(zipURL) to \(baseURL)")
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(zipURL, withName: "file")
        }, to: baseURL, method: .post, headers: ["Content-Type": "application/zip"])
            .uploadProgress { progress in
                if let uploadProgress = uploadProgress {
                    uploadProgress.wrappedValue = progress.fractionCompleted
                }
                print("Upload Progress: \(progress.fractionCompleted)")
            }
            .responseData { response in
                print(response)
                
                switch response.result {
                case .success:
                    if response.value != nil {
                        // TODO: Write into log
                        completion(true)
                    } else {
                        logger.error("Upload request is nil)")
                        completion(false)
                    }
                case .failure(let error):
                    logger.error("Upload request failed with error: \(error)")
                    completion(false)
                }
                do {
                    try FileManager.default.removeItem(at: zipURL)
                } catch {
                    logger.error("Fail to delete zipfile: \(error)")
                }
            }
    } catch {
        logger.error("Error zipping files: \(error)")
        completion(false)
    }
}
