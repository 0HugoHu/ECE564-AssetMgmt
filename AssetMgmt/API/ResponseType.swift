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


struct SetFieldsResponse: Codable {
    let id: Int
    let triggerAssetModified: Bool
}


struct Fields: Codable, Equatable {
    var title: [String]?
    var keyword: [String]?
    var description: String?
    var creator: [String]?
    var rights: [String]?
    var contributor: [String]?
    var publisher: [String]?
    var coverage: String?
    var date: [String]?
    var identifier: String?
    var source: String?
    var format: String?

    enum CodingKeys: String, CodingKey {
        case title = "http://purl.org/dc/elements/1.1/ title"
        case keyword = "http://purl.org/dc/elements/1.1/ subject"
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

extension Fields {
    func toCustomJSON(id: Int) -> [String: Any] {
        var fieldsArray: [[String: Any]] = []

        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            guard let key = child.label, let codingKey = codingKey(for: key) else { continue }
            
            if let value = child.value as? String {
                fieldsArray.append(["fieldId": codingKey, "value": value, "append": false])
            } else if let valueArray = child.value as? [String] {
                let value = valueArray.joined(separator: ", ")
                fieldsArray.append(["fieldId": codingKey, "value": value, "append": false])
            }
        }

        return ["id": id, "fields": fieldsArray]  // Example ID used
    }

    private func codingKey(for label: String) -> String? {
        switch label {
            case "title": return "http://purl.org/dc/elements/1.1/ title"
            case "keyword": return "http://purl.org/dc/elements/1.1/ subject"
            case "description": return "http://purl.org/dc/elements/1.1/ description"
            case "creator": return "http://purl.org/dc/elements/1.1/ creator"
            case "rights": return "http://purl.org/dc/elements/1.1/ rights"
            case "contributor": return "http://purl.org/dc/elements/1.1/ contributor"
            case "publisher": return "http://purl.org/dc/elements/1.1/ publisher"
            case "coverage": return "http://purl.org/dc/elements/1.1/ coverage"
            case "date": return "http://purl.org/dc/elements/1.1/ date"
            case "identifier": return "http://purl.org/dc/elements/1.1/ identifier"
            case "source": return "http://purl.org/dc/elements/1.1/ source"
            case "format": return "http://purl.org/dc/elements/1.1/ format"
            default: return nil
        }
    }
}
