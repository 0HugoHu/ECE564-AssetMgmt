//
//  RemoveFile.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/2/23.
//

import Foundation

func removeFile(atPath filePath: String) {
    let fileManager = FileManager.default
    
    do {
        if fileManager.fileExists(atPath: filePath) {
            try fileManager.removeItem(atPath: filePath)
        } else {
            logger.warning("File does not exist at the specified path.")
        }
    } catch {
        logger.warning("Error removing the file: \(error)")
    }
}


