//
//  FileAccess.swift
//  AssetMgmt
//
//  Created by Athenaost on 11/8/23.
//

import Foundation
import SwiftUI

let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appending(path: "edu.duke.AssetMgmt/DownloadFiles")

func getFilePathById(_ id: String, progress: Binding<Int64>? = nil) -> URL? {
    if let progress = UserDefaults.standard.value(forKey: "download@\(id)") as? Int64 {
        if progress != -1 {
            return nil
        }
    }
    let folderPath = cacheURL.appending(path: id)
    if !FileManager.default.fileExists(atPath: folderPath.absoluteString) {
        do {
            try FileManager.default.createDirectory(at: folderPath, withIntermediateDirectories: true)
        } catch {
            logger.error("Fail to create directory: \(error)")
            return nil
        }
    }
    do {
        if let file = try FileManager.default.contentsOfDirectory(at: folderPath).first {
            return file
        }
    } catch {
        logger.error("Read cache error: \(error)")
        return nil
    }
    downloadFiles(to: folderPath, ids: [id], progress: progress) {result in}
    return nil
}
