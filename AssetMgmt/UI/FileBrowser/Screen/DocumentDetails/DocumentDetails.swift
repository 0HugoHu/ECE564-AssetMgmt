//
//  DocumentDetails.swift
//  AssetMgmt
//
//  Created by ntsh (https://github.com/ntsh/DirectoryBrowser)
//  Adapted by Hugooooo on 11/11/23.
//

import FilePreviews
import SwiftUI

struct DocumentDetails: View {
    var document: Document
    var mode: FileBrowserMode
    
    @State private var dcFields: Fields?
    @State private var urlToPreview: URL?
    @State private var progress: Int64 = 0
    @State private var waitToShow: Bool = false
    @State private var retryCount = 0
    @State private var timer: Timer?
    
    public init(document: Document, mode: FileBrowserMode) {
        self.document = document
        self.mode = mode
    }
    
    var body: some View {
        
        let viewModel = DocumentFieldsViewModel(dcFields: dcFields ?? Fields(), id: document.mediaBeaconID)
        
        VStack(alignment: .center, spacing: 12) {
            List {
                if mode == .remote {
                    if let thumbnailUrl = getHighQualityPreviewURL(originalURLString: document.highQualityPreviewUrl ?? "") {
                        VStack (alignment: .center) {
                            AsyncImage(url: URL(string: thumbnailUrl)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    stopRetryTimer()
                                    
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 260)
                                        .cornerRadius(10)
                                case .failure:
                                    startRetryTimer()
                                    
                                    VStack (alignment: .center) {
                                        Image("icon_preview_fail")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 160, height: 160)
                                        Text("Loading Preview...")
                                    }
                                @unknown default:
                                    stopRetryTimer()
                                    
                                    VStack (alignment: .center) {
                                        Image("icon_preview_fail")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 160, height: 160)
                                        Text("Unsupported File Type")
                                    }
                                }
                            }
                            .id(retryCount)
                        }
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            showPreview()
                        }
                    } else {
                        VStack (alignment: .center) {
                            Image("doc.questionmark.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 160, height: 160)
                            
                            Text("Unsupported File Type")
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                
                HStack {
                    Spacer()
                    VStack {
                        Text(document.name)
                            .multilineTextAlignment(.center)
                            .font(.headline)
                        
                        CustomePreviewView()
                    }
                    Spacer()
                }
                
                
                if progress != 0 {
                    if progress == -1 {
                        DocumentAttributeRow(key: "Downloaded", value: document.formattedSize)
                    } else {
                        DocumentAttributeRow(key: "Downloaded", value: Int64(truncating: progress as NSNumber).formatted(ByteCountFormatStyle()))
                    }
                }
                DocumentAttributeRow(key: "Size", value: document.formattedSize)
                
                if let created = document.created {
                    DocumentAttributeRow(key: "Created", value: created.formatted())
                }
                
                if let modified = document.modified {
                    DocumentAttributeRow(key: "Modified", value: modified.formatted())
                }
                
                DCSectionView(viewModel: viewModel)
            }
            .listStyle(InsetGroupedListStyle())
        }
        .quickLookPreview($urlToPreview)
        .navigationBarItems(trailing: HStack {
            Button(action: showPreview) {
                Label("Preview", systemImage: "play.fill")
            }.foregroundColor(.blue)
        })
        .onAppear() {
            if let data = UserDefaults.standard.value(forKey: "download@\(document.mediaBeaconID)") {
                if let value = data as? Int64 {
                    progress = value
                }
            }
        }
        .onAppear {
            getDublinCore(ids: [String(document.mediaBeaconID)]) { DublinCoreInfo in
                DispatchQueue.main.async {
                    
                    if let dcFields = DublinCoreInfo?.first?.fields{
                        self.dcFields = dcFields
                    }
                    
                }
            }
        }
        .onChange(of: progress) { newValue in
            if newValue == -1 && waitToShow {
                showPreview()
            }
        }
    }
    
    func showPreview() {
        urlToPreview = getFilePathById(String(document.mediaBeaconID), progress: $progress)
        waitToShow = true
    }
    
    private func startRetryTimer() -> some View {
        if timer != nil {
            return EmptyView()
        }
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) {  timer in
            self.retryCount += 1
        }
        return EmptyView()
    }
    
    private func stopRetryTimer() -> some View {
        timer?.invalidate()
        return EmptyView()
    }
}


