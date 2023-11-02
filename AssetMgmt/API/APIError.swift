//
//  APIError.swift
//  AssetMgmt
//
//  Created by Hugooooo on 10/31/23.
//

import Foundation

enum APIError: Error {
    case emptyResponseData
    case requestFailed(Error)
    case invalidResponse
}

