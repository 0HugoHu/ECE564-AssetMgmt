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
        VStack(alignment: .center, spacing: 12) {
            List {
                if mode == .local {
                    ThumbnailView(url: document.url)
                        .padding(.vertical)
                        .onTapGesture(perform: showPreview)
                } else if mode == .remote {
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
                
                Section(header: Text("Dublin Core Metadata")) {
                    
                    
                    if let title = dcFields?.title?.joined(separator: ", ") {
                        DocumentAttributeRow(key: "Title", value: title)
                    }
                    if let keyword = dcFields?.keyword?.joined(separator: ", ") {
                        DocumentAttributeRow(key: "Keywords", value: keyword)
                    }
                    if let description = dcFields?.description {
                        DocumentAttributeRow(key: "Description", value: description)
                    }
                    if let creator = dcFields?.creator?.joined(separator: ", ") {
                        DocumentAttributeRow(key: "Creators", value: creator)
                    }
                    if let rights = dcFields?.rights?.joined(separator: ", ") {
                        DocumentAttributeRow(key: "Rights", value: rights)
                    }
                    if let contributor = dcFields?.contributor?.joined(separator: ", ") {
                        DocumentAttributeRow(key: "Contributors", value: contributor)
                    }
                    if let publisher = dcFields?.publisher?.joined(separator: ", ") {
                        DocumentAttributeRow(key: "Publisher", value: publisher)
                    }
                    if let coverage = dcFields?.coverage {
                        DocumentAttributeRow(key: "Coverage", value: coverage)
                    }
                    if let date = dcFields?.date?.joined(separator: ", ") {
                        DocumentAttributeRow(key: "Date", value: date)
                    }
                    if let identifier = dcFields?.identifier {
                        DocumentAttributeRow(key: "Identifier", value: identifier)
                    }
                    if let source = dcFields?.source {
                        DocumentAttributeRow(key: "Source", value: source)
                    }
                    if let format = dcFields?.format {
                        DocumentAttributeRow(key: "Format", value: format)
                    }
                }
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
                        print(dcFields)
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
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) {  timer in
            self.retryCount += 1
        }
        return EmptyView()
    }
    
    private func stopRetryTimer() -> some View {
        timer?.invalidate()
        return EmptyView()
    }
}

struct DocumentDetails_Previews: PreviewProvider {
    static var previews: some View {
        DocumentDetails(document: DocumentsStore_Preview(root: URL.temporaryDirectory, relativePath: "/", sorting: .date(ascending: true)).documents[1], mode: .remote)
            .preferredColorScheme(.dark)
            .environment(\.sizeCategory, .large)
    }
}
