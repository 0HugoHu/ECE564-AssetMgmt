//
//  FileAccess.swift
//  AssetMgmt
//
//  Created by Janus on 11/8/23.
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


func removeFileById(_ id: String) {
    UserDefaults.standard.removeObject(forKey: "download@\(id)")
    do {
        let folderPath = cacheURL.appending(path: id)
        try FileManager.default.removeItem(at: folderPath)
        logger.info("Cache deleted, id: \(id)")
    } catch {
        logger.info("No cache for id: \(id), nothing to be deleted")
    }
}


func deleteAllFilesInCacheFolder() {
    do {
        let fileURLs = try FileManager.default.contentsOfDirectory(at: cacheURL)
        for fileURL in fileURLs {
            try FileManager.default.removeItem(at: fileURL)
            UserDefaults.standard.removeObject(forKey: "download@\(fileURL.lastPathComponent)")
            logger.info("File deleted: \(fileURL.lastPathComponent)")
        }
    } catch {
        logger.error("Failed to delete files in folder: \(cacheURL.path), error: \(error)")
    }
}

