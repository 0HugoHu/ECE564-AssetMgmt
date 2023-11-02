import SwiftUI
import FilePreviews

public struct DirectoryBrowser: View {
    @StateObject var thumbnailer = Thumbnailer()
    private var urls: [URL]

    public init(
        urls: [URL] = [.documentsDirectory, .libraryDirectory, .temporaryDirectory]
    ) {
        self.urls = urls
    }

    public var body: some View {
        NavigationView {
            List {
                ForEach(urls, id:\.self) { url in
                    NavigationLink(url.lastPathComponent) {
                        FolderView(documentsStore: DocumentsStore(root: url), title: url.lastPathComponent)
                    }
                }
                
                NavigationLink(destination: SearchView()) {
                    Text("Search")
                }
                NavigationLink(destination: PDFSwiftUIView(fileName: "Sample"), label: {
                    Text("PDF viewer")
                })
                NavigationLink(destination: DownloadView()
                ) {
                    Text("Download Test")
                }
                NavigationLink(destination: UploadView()
                ) {
                    Text("Upload Test")
                }
            }
        }
        .environmentObject(thumbnailer)
    }
}

struct DirectoryBrowser_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DirectoryBrowser()
                .preferredColorScheme(.light)

            DirectoryBrowser()
                .preferredColorScheme(.dark)
        }
    }
}
