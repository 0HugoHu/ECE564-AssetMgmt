import SwiftUI
import FilePreviews

public struct DirectoryBrowser: View {
    @StateObject var thumbnailer = Thumbnailer()
    
    public var body: some View {
        TabView {
            FolderView(documentsStore: DocumentsStore(root: "/", mode: .remote), title: "Index")
                .tabItem {
                    Image(systemName: "folder")
                    Text("Browse")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Account")
                }
        }
        .environmentObject(thumbnailer)
        .background(Color(UIColor.systemBackground))
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
