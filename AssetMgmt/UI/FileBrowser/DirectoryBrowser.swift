//
//  DirectoryBrowser.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/3/23.
//

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

