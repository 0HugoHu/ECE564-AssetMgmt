import SwiftUI
import FilePreviews

public struct DirectoryBrowser: View {
    @StateObject var thumbnailer = Thumbnailer()
    
    public var body: some View {
        //        NavigationView {
        List {
            NavigationLink(destination: SearchView()) {
                Text("Search")
            }
            NavigationLink(destination: FolderView(documentsStore: DocumentsStore(root: "/", mode: .remote), title: "Index")) {
                Text("Index")
            }
            NavigationLink(destination: UploadView()
            ) {
                Text("Upload Test")
            }
        }
        //        }
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
