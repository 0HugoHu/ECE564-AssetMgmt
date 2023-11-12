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
                        .frame(width: 80, height: 80)
                case .failure:
                    Image("icon_directory")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                @unknown default:
                    EmptyView()
                }
            }
        }
    }
}
