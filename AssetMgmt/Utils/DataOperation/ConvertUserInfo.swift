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
    if let accountInfoResponse : UserInfoAPIResponse = getUserInfo() {
        accountInfo["Username"] = accountInfoResponse.username == "" ? "N/A" : accountInfoResponse.username
        accountInfo["Status"] = accountInfoResponse.username == "" ? "N/A" : accountInfoResponse.status
        accountInfo["FirstName"] = accountInfoResponse.username == "" ? "N/A" : accountInfoResponse.firstName
        accountInfo["LastName"] = accountInfoResponse.username == "" ? "N/A" : accountInfoResponse.lastName
        accountInfo["Type"] = accountInfoResponse.username == "" ? "N/A" : accountInfoResponse.type
        accountInfo["Department"] = accountInfoResponse.username == "" ? "N/A" : accountInfoResponse.dept
        saveUserInfo(accountInfoResponse)
    } else {
        getUserInfo() { result in
            if result != nil {
                let unwrappedResult = result!
                accountInfo["Username"] = unwrappedResult.username == "" ? "N/A" : unwrappedResult.username
                accountInfo["Status"] = unwrappedResult.username == "" ? "N/A" : unwrappedResult.status
                accountInfo["FirstName"] = unwrappedResult.username == "" ? "N/A" : unwrappedResult.firstName
                accountInfo["LastName"] = unwrappedResult.username == "" ? "N/A" : unwrappedResult.lastName
                accountInfo["Type"] = unwrappedResult.username == "" ? "N/A" : unwrappedResult.type
                accountInfo["Department"] = unwrappedResult.username == "" ? "N/A" : unwrappedResult.dept
                saveUserInfo(unwrappedResult)
            }
        }
    }
    return accountInfo
}
