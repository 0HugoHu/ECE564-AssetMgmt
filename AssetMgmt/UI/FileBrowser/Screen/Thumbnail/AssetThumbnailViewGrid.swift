//
//  AssetThumbnailView.swift
//  AssetMgmt
//
//  Created by Minghui ZHU on 11/6/23.
//

import SwiftUI

struct AssetThumbnailViewGrid: View {
    let assetInfo: AssetInfoResponse
    
    var body: some View {
        VStack {
            
            let thumbnailUrl = getThumbnailURL(originalURLString: assetInfo.previews.thumbnail)
            
            AsyncImage(url: URL(string: thumbnailUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView() // Display a loader until the image loads
                case .success(let image):
                    image.resizable() // Display the loaded image
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                case .failure:
                    Image(systemName: "photo") // Display a fallback image in case of failure
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                @unknown default:
                    EmptyView() // Future-proofing against new cases
                }
                
                VStack(alignment: .leading) {
                    Text(assetInfo.name)
                        .font(Font.system(size: 14))
                        .lineLimit(2)
                        .allowsTightening(true)
                        .foregroundColor(Color.primary)
                }
            }
            .padding(5)
        }
    }
}
