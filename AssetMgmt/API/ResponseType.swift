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


struct DublinCoreResponse: Codable {
    let id: Int
    let fields: Fields

    enum CodingKeys: String, CodingKey {
        case id
        case fields
    }
}

struct Fields: Codable {
    let title: [String]?
    let subject: [String]?
    let description: String?
    let creator: [String]?
    let rights: [String]? // Changed to an array based on your JSON response
    let contributor: [String]?
    let publisher: [String]?
    let coverage: String?
    let date: String?
    let identifier: String?
    let source: String?
    let format: String?

    enum CodingKeys: String, CodingKey {
        case title = "http://purl.org/dc/elements/1.1/ title"
        case subject = "http://purl.org/dc/elements/1.1/ subject"
        case description = "http://purl.org/dc/elements/1.1/ description"
        case creator = "http://purl.org/dc/elements/1.1/ creator"
        case rights = "http://purl.org/dc/elements/1.1/ rights"
        case contributor = "http://purl.org/dc/elements/1.1/ contributor"
        case publisher = "http://purl.org/dc/elements/1.1/ publisher"
        case coverage = "http://purl.org/dc/elements/1.1/ coverage"
        case date = "http://purl.org/dc/elements/1.1/ date"
        case identifier = "http://purl.org/dc/elements/1.1/ identifier"
        case source = "http://purl.org/dc/elements/1.1/ source"
        case format = "http://purl.org/dc/elements/1.1/ format"
    }
}

