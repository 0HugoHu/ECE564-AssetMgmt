import SwiftUI
import FilePreviews

public struct DirectoryBrowser: View {
    @StateObject var thumbnailer = Thumbnailer()
    
    public var body: some View {
        FolderView(documentsStore: DocumentsStore(root: "/", mode: .remote), title: "Index")
            .environmentObject(thumbnailer)
            .task {
                setACLGroups()
            }
            .navigationBarTitleDisplayMode(.inline)
    }
    
    private func setACLGroups() {
        getACLGroups(completion: { result in
            if let ACLGroups = result {
                if let jsonData = try? JSONEncoder().encode(ACLGroups) {
                    UserDefaults.standard.setValue(jsonData, forKey: "ACLGroups")
                    if UserDefaults.standard.value(forKey: "selectedACL") == nil {
                        UserDefaults.standard.setValue(ACLGroups[0].id, forKey: "selectedACL")
                    }
                }
            }
        })
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
