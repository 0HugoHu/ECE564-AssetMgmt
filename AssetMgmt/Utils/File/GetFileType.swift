//
//  GetFileType.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/2/23.
//

import Foundation

func fileExtensionForContentType(_ contentType: String) -> String? {
    let contentTypeToExtension = [
        "application/pdf": "pdf",
        "image/jpeg": "jpg",
        "image/png": "png",
        "application/msword": "doc",
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document": "docx",
        "application/vnd.ms-excel": "xls",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet": "xlsx",
        "application/vnd.ms-powerpoint": "ppt",
        "application/vnd.openxmlformats-officedocument.presentationml.presentation": "pptx",
        "application/zip": "zip",
        "text/plain": "txt",
        "application/json": "json",
        // Add more mappings as needed
    ]

    return contentTypeToExtension[contentType]
}
