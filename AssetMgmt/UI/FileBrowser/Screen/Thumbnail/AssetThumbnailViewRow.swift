//
//  AssetThumbnailViewRow.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/9/23.
//

import Foundation
import SwiftUI

struct AssetThumbnailViewRow: View {
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
                        .frame(width: 60, height: 60)
                case .failure:
                    Image(uiImage: themeManager.getDirectoryIcon())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                @unknown default:
                    EmptyView()
                }
            }
        }
    }
}
