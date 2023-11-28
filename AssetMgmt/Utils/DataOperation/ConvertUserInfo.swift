//
//  ConvertUserInfo.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/20/23.
//

import Foundation

var accountInfo: [String: String] = [
    "Username": "N/A",
    "Status": "N/A",
    "FirstName": "N/A",
    "LastName": "N/A",
    "Type": "N/A",
    "Department": "N/A"
]

func getAccountInfo() -> [String: String] {
    getUserInfo() { result in
        if result != nil {
            let unwrappedResult = result!
            accountInfo["Username"] = unwrappedResult.username == "" ? "N/A" : unwrappedResult.username
            accountInfo["Status"] = unwrappedResult.status == "" ? "N/A" : unwrappedResult.status
            accountInfo["FirstName"] = unwrappedResult.firstName == "" ? "N/A" : unwrappedResult.firstName
            accountInfo["LastName"] = unwrappedResult.lastName == "" ? "N/A" : unwrappedResult.lastName
            accountInfo["Type"] = unwrappedResult.type == "" ? "N/A" : unwrappedResult.type
            accountInfo["Department"] = unwrappedResult.dept == "" ? "N/A" : unwrappedResult.dept
            saveUserInfo(unwrappedResult)
        }
    }
    return accountInfo
}
