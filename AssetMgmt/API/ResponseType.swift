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
    let firstName: String
    let middleName: String
    let lastName: String
    let status: String
    let type: String
    let address1: String
    let address2: String
    let city: String
    let company: String
    let country: String
    let state: String
    let zip: String
    let dept: String
    let email: String
    let ext: String
    let phone: String
    let position: String
    let wcrEnabled: Bool
    let blueEnabled: Bool
}

