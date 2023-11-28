//
//  UserDefaultAccess.swift
//  AssetMgmt
//
//  Created by Janus on 11/1/23.
//

import Foundation

func saveUserInfo(_ userInfo: UserInfoAPIResponse) {
    do {
        let data = try JSONEncoder().encode(userInfo)
        UserDefaults.standard.set(data, forKey: "userInfo")
    } catch {
        logger.error("\(error)")
    }
}


func getUserInfo() -> UserInfoAPIResponse? {
    if let data = UserDefaults.standard.data(forKey: "userInfo") {
        do {
            let userInfo = try JSONDecoder().decode(UserInfoAPIResponse.self, from: data)
            return userInfo
        } catch {
            logger.error("\(error)")
        }
    }
    return nil
}
