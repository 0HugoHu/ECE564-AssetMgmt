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

func getGroupsURL() -> URL {
    return appendAuth(url: URL(string: REST_API + "groups")!)
}

func setFieldsURL() -> URL {
    return appendAuth(url: URL(string: REST_API + "setFields")!)
}

func appendAuth(url: URL) -> URL {
    if let authToken = UserDefaults.standard.string(forKey: "AuthToken") {
        return URL(string: url.absoluteString + "?apikey=" + authToken + "&acl_id=0_42_A754B8A8-8E5C-4477-8466-894915E29E81")!
    }
    return url
}


func getThumbnailURL(originalURLString: String) -> String {
    let baseOld = PREVIEW_HOST
    let baseNew = MEDIABEACON_HOST
    
    if originalURLString.hasPrefix(baseOld) {
        var newURLString = originalURLString.replacingOccurrences(of: baseOld, with: baseNew)
        newURLString += "&apikey=\(UserDefaults.standard.string(forKey: "AuthToken")!)"
        return newURLString
    } else {
        return originalURLString // Return the original if it doesn't match the expected format
    }
}


func getHighQualityPreviewURL(originalURLString: String) -> String? {
    let baseOld = PREVIEW_HOST
    let baseNew = MEDIABEACON_HOST
    
    if originalURLString.hasPrefix(baseOld) {
        var newURLString = originalURLString.replacingOccurrences(of: baseOld, with: baseNew)
        newURLString += "&apikey=\(UserDefaults.standard.string(forKey: "AuthToken")!)"
        return newURLString
    } else {
        return nil
    }
}

// TODO: Append other URLs here
// https://mb-buildstorage.s3.amazonaws.com/23.07/Current/API/Rest-v2/symbols/Assets.html
