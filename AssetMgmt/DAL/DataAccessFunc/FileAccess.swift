//
//  FileAccess.swift
//  AssetMgmt
//
//  Created by Athenaost on 11/8/23.
//

import Foundation

let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appending(path: "edu.duke.AssetMgmt/DownloadFiles")

func getFilePathById(_ id: String) -> URL? {
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
    var done = false
    downloadFiles(to: folderPath, ids: [id]) {result in
        done = true
    }
    while !done {}
    do {
        if let file = try FileManager.default.contentsOfDirectory(at: folderPath).first {
            return file
        } else {
            logger.error("Download error")
        }
    } catch {
        logger.error("Read cache error: \(error)")
    }
    return nil
}
