//
//  ImageUtils.swift
//  AssetMgmt
//
//  Created by Minghui ZHU on 11/1/23.
//

import Foundation
import SwiftUI

func getFileIcon(type: String) -> Image {
    switch type {
    case "doc":
        return Image("docIcon")
    case "jpg":
        return Image("jpgIcon")
    case "mov":
        return Image("movIcon")
    case "mp3":
        return Image("mp3Icon")
    case "pdf":
        return Image("pdfIcon")
    case "png":
        return Image("pngIcon")
    default:
        return Image("fileIcon")
    }
}
