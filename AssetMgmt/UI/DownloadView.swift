//
//  DownloadView.swift
//  AssetMgmt
//
//  Created by Hugooooo on 11/2/23.
//

import SwiftUI

struct DownloadView: View {
    @State private var downloadCompleted = false
    
    var body: some View {
        Text("Files will be downloaded to /Documents")
            .onAppear(perform: {
                let savePath = URL.documentsDirectory
                let testID = ["205596017"]
                
                downloadFiles(to: savePath, ids: testID) { success in
                    downloadCompleted = true
                }
            })
        
        Text("Download complete: \(downloadCompleted ? "Yes" : "No")")
    }
}

#Preview {
    DownloadView()
}
