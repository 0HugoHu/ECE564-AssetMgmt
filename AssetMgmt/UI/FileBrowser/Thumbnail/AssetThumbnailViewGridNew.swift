//
//  AssetThumbnailViewGridNew.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/12/23.
//

import Foundation
import SwiftUI

struct AssetThumbnailViewGridNew: View {
    let url: String
    @StateObject var themeManager = Themes.instance
    
    var body: some View {
        VStack {
            let thumbnailUrl = getThumbnailURL(originalURLString: url)
         
            AsyncImage(url: URL(string: thumbnailUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 90, height: 90)
                case .failure:
                    Image(uiImage: themeManager.getDirectoryIcon())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 90, height: 90)
                @unknown default:
                    EmptyView()
                }
            }
        }
    }
}
