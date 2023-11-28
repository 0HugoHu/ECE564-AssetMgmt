//
//  DocumentDetails.swift
//  AssetMgmt
//
//  Created by ntsh (https://github.com/ntsh/DirectoryBrowser)
//

import Foundation

extension URL: Identifiable {
    public var id: String {
        absoluteString
    }
}
