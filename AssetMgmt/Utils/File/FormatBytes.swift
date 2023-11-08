//
//  FormatBytes.swift
//  AssetMgmt
//
//  Created by Minghui ZHU on 11/8/23.
//

import Foundation

func formatBytes(_ bytes: Int) -> String {
    let formatter = ByteCountFormatter()
    formatter.allowedUnits = [.useBytes, .useKB, .useMB, .useGB] // You can adjust this depending on which units you want to allow
    formatter.countStyle = .file
    return formatter.string(fromByteCount: Int64(bytes))
}
