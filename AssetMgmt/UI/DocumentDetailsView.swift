//
//  DocumentDetailsView.swift
//  AssetMgmt
//
//  Created by Minghui ZHU on 11/8/23.
//

import FilePreviews
import SwiftUI

struct DocumentDetailsView: View {
    
    @State private var previewURL: URL?
    
    var assetInfo: AssetInfoResponse
//    @State private var urlToPreview: URL?
    @State private var showPDF = false


    var body: some View {
        
        let thumbnailUrl: URL = URL(string: getThumbnailURL(originalURLString: assetInfo.previews.high))!
   
        VStack(alignment: .center, spacing: 12) {
            List {
//                ThumbnailView(url: getFilePathById(String(assetInfo.id))!)
                AsyncImage(url: thumbnailUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView() // Display a loader until the image loads
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Image(systemName: "photo") // Display a fallback image in case of failure
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(contentMode: .fill)
                    @unknown default:
                        EmptyView() // Future-proofing against new cases
                    }
                }
                .onTapGesture {
                    self.showPDF = true
                    previewURL = getFilePathById(String(assetInfo.id))
                    print(assetInfo.id)
                }
//                .background(
//                    NavigationLink(
//                        destination: PDFViewer(url: getFilePathById(String(assetInfo.id))!),
//                        //destination: PDFViewer(url: URL(string: getThumbnailURL(originalURLString: assetInfo.previews.downloadUrl))!),
//                        isActive: $showPDF
//                    ) {
//                        EmptyView()
//                    }
//                    .hidden()
//                )

                HStack {
                    Spacer()
                    Text(assetInfo.name)
                        .multilineTextAlignment(.center)
                        .font(.headline)
                    Spacer()
                }

                // TODO: Changed by Hugo, did not test corner cases
                DocumentAttributeRow(key: "Type", value: fileExtensionForContentType(assetInfo.mimeType ?? "unknown")!)
                DocumentAttributeRow(key: "Size", value: formatBytes(assetInfo.bytes))
                

//                if let created = document.created {
//                    DocumentAttributeRow(key: "Created", value: created.formatted())
//                }
//
//                if let modified = assetInfo.lastModified {
//                    DocumentAttributeRow(key: "Modified", value: modified.formatted())
//                }
            }
            
            .listStyle(InsetGroupedListStyle())
        }
        .quickLookPreview($previewURL)
//        .navigationBarItems(trailing: HStack {
//            Button(action: showPreview) {
//                Image(systemName: "play.fill")
//                    .font(.largeTitle)
//            }.foregroundColor(.blue)
//        }
//    )
    }

//    func showPreview() {
//        urlToPreview = URL(string: getThumbnailURL(originalURLString: assetInfo.previews.downloadUrl))!
//    }
}

//struct DocumentDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DocumentDetailsView(assetInfo: <#T##AssetInfoResponse#>)
//            .preferredColorScheme(.dark)
//            .environment(\.sizeCategory, .large)
//    }
//}

