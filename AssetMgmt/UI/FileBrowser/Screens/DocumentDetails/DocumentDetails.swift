import FilePreviews
import SwiftUI

struct DocumentDetails: View {
    var document: Document

    @State private var urlToPreview: URL?
    @State private var progress: Int64 = 0

    public init(document: Document) {
        self.document = document
    }

    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            List {
                ThumbnailView(url: document.url)
                    .padding(.vertical)
                    .onTapGesture(perform: showPreview)

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
                Image(systemName: "play.fill")
                    .font(.largeTitle)
            }.foregroundColor(.blue)
        })
        .onAppear() {
            if let data = UserDefaults.standard.value(forKey: "download@\(document.mediaBeaconID)") {
                if let value = data as? Int64 {
                    progress = value
                }
            }
        }
    }

    func showPreview() {
        urlToPreview = getFilePathById(String(document.mediaBeaconID), progress: $progress)
    }
}

struct DocumentDetails_Previews: PreviewProvider {
    static var previews: some View {
        DocumentDetails(document: DocumentsStore_Preview(root: URL.temporaryDirectory, relativePath: "/", sorting: .date(ascending: true)).documents[1])
            .preferredColorScheme(.dark)
            .environment(\.sizeCategory, .large)
    }
}
