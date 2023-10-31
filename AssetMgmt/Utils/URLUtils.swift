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


func appendAuth(url: URL) -> URL {
    if let authToken = UserDefaults.standard.string(forKey: "AuthToken") {
        return URL(string: url.absoluteString + "?apikey=" + authToken)!
    }
    return url
}


// TODO: Append other URLs here
// https://mb-buildstorage.s3.amazonaws.com/23.07/Current/API/Rest-v2/symbols/Assets.html
