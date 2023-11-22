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
    // TODO: Cannot use cache here, because it's not constant
//    if let accountInfoResponse : UserInfoAPIResponse = getUserInfo() {
//        accountInfo["Username"] = accountInfoResponse.username == "" ? "N/A" : accountInfoResponse.username
//        accountInfo["Status"] = accountInfoResponse.status == "" ? "N/A" : accountInfoResponse.status
//        accountInfo["FirstName"] = accountInfoResponse.firstName == "" ? "N/A" : accountInfoResponse.firstName
//        accountInfo["LastName"] = accountInfoResponse.lastName == "" ? "N/A" : accountInfoResponse.lastName
//        accountInfo["Type"] = accountInfoResponse.type == "" ? "N/A" : accountInfoResponse.type
//        accountInfo["Department"] = accountInfoResponse.dept == "" ? "N/A" : accountInfoResponse.dept
//    } else {
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
//    }
//    logger.info("accountInfo: \(accountInfo["Department"]!)")
    return accountInfo
}
