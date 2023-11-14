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
                        .frame(width: 100, height: 100)
                case .failure:
                    Image(systemName: "photo") // Display a fallback image in case of failure
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                @unknown default:
                    EmptyView() // Future-proofing against new cases
                }
    
                VStack{
                    Text(assetInfo.name)
                        .font(.caption)
//                        .lineLimit(1)  Ensure the text does not take up more than one line


//                    Text(fileExtensionForContentType(assetInfo.mimeType ?? "unknown"))
//                        .font(.footnote)
//                        .foregroundColor(.secondary) // For ma
//                    

                }
            }
            .padding(5)
        }
    }
}
