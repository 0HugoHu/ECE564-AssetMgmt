//
//  URLUtils.swift
//  AssetMgmt
//
//  Created by Hugooooo on 10/29/23.
//

import Foundation


func getGetAPIKeyURL() -> URL {
    return URL(string: REST_API + "getAPIKey")!
}


func getUserInfoURL() -> URL {
    return appendAuth(url: URL(string: REST_API + "userInfo")!)
}


func getDownloadURL() -> URL {
    return appendAuth(url: URL(string: REST_API + "download")!)
}


func getUploadURL() -> URL {
    return appendAuth(url: URL(string: REST_API + "upload")!)
}


func getRenameURL() -> URL {
    return appendAuth(url: URL(string: REST_API + "rename")!)
}

func getDeleteURL() -> URL {
    return appendAuth(url: URL(string: REST_API + "delete")!)
}

func getCreateURL() -> URL {
    return appendAuth(url: URL(string: REST_API + "create")!)
}


func getSimpleSearchURL() -> URL {
    return appendAuth(url: URL(string: REST_API + "quickSearch")!)
}

func getAdvancedSearchURL() -> URL {
    return appendAuth(url: URL(string: REST_API + "search")!)
}


func getAssetInfoURL() -> URL {
    return appendAuth(url: URL(string: REST_API + "assets")!)
}


func getDirectoryURL() -> URL {
    return appendAuth(url: URL(string: REST_API + "directories")!)
}


func appendAuth(url: URL) -> URL {
    if let authToken = UserDefaults.standard.string(forKey: "AuthToken") {
        return URL(string: url.absoluteString + "?apikey=" + authToken)!
    }
    return url
}


func getThumbnailURL(originalURLString: String) -> String {
    let baseOld = "https://152.3.100.163:443/"
    let baseNew = MEDIABEACON_HOST
    
    if originalURLString.hasPrefix(baseOld) {
        var newURLString = originalURLString.replacingOccurrences(of: baseOld, with: baseNew)
        newURLString += "&apikey=\(UserDefaults.standard.string(forKey: "AuthToken")!)"
        return newURLString
    } else {
        return originalURLString // Return the original if it doesn't match the expected format
    }
}

// TODO: Append other URLs here
// https://mb-buildstorage.s3.amazonaws.com/23.07/Current/API/Rest-v2/symbols/Assets.html
