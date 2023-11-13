import FilePreviews
import SwiftUI

struct DocumentDetails: View {
    var document: Document
    var mode: FileBrowserMode

    @State private var urlToPreview: URL?
    @State private var progress: Int64 = 0
    @State private var waitToShow: Bool = false

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
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 260)
                                case .failure:
                                    Image("icon_directory")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 160, height: 160)
                                @unknown default:
                                    EmptyView()
                                }
                            }
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
                    Text(document.name)
                        .multilineTextAlignment(.center)
                        .font(.headline)
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
}

struct DocumentDetails_Previews: PreviewProvider {
    static var previews: some View {
        DocumentDetails(document: DocumentsStore_Preview(root: URL.temporaryDirectory, relativePath: "/", sorting: .date(ascending: true)).documents[1], mode: .remote)
            .preferredColorScheme(.dark)
            .environment(\.sizeCategory, .large)
    }
}
