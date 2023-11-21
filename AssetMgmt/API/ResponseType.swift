//
//  ResponseType.swift
//  AssetMgmt
//
//  Created by Hugooooo on 10/31/23.
//

import Foundation

struct PlainTextAPIResponse: Codable {
    let result: String
}

struct UserInfoAPIResponse: Codable {
    let username: String
    let status: String
    let firstName: String
    let lastName: String
    let type: String
    let dept: String
    let address1: String
    let address2: String
    let city: String
    let company: String
    let country: String
    let state: String
    let zip: String
    let email: String
    let ext: String
    let phone: String
    let position: String
    let wcrEnabled: Bool
    let blueEnabled: Bool
    let middleName: String
}


struct SimpleIDResponse: Codable, Identifiable {
    let id: Int
}


struct AssetInfoResponse: Codable, Identifiable {
    let id: Int
    let name: String
    let path: String
    let directoryId: Int
    let height: Int
    let width: Int
    let bytes: Int
    let lastModified: Double
    let mimeType: String?
    let previews: Previews
    let replaceDate: Int
    let versionNumber: Int

    struct Previews: Codable {
        let thumbnail: String
        let viewex: String
        let high: String
        let downloadUrl: String
    }
}


struct DirectoryResponse: Codable, Identifiable {
    let id: Int
    let name: String
    let path: String
    let resolver: String
    let hasChildren: Bool?
    let parentId: Int?
}


