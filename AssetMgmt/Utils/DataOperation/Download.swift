//
//  Download.swift
//  AssetMgmt
//
//  Created by Hugooooo on 10/31/23.
//

import Foundation
import SwiftUI

/*
 Download a file from a URL to a destination URL
 
 - Parameters:
 - url: The URL to download from
 - destinationURL: The URL to download to
 - completion: A closure that is called when the download is complete
 */
func download(from url: URL, to destinationURL: URL, progress: Binding<Int64>?, fileId: String) {
    let customDelegate = CustomURLDelegate(progress: progress, destinationURL: destinationURL, fileId: fileId)
    let session = URLSession(configuration: .default, delegate: customDelegate, delegateQueue: OperationQueue())
    let downloadTask = session.downloadTask(with: url) 
    downloadTask.resume()
}
