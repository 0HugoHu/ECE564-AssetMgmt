//
//  PDFSwiftUIView.swift
//  AssetMgmt
//
//  Created by Athenaost on 11/1/23.
//

import SwiftUI

struct PDFSwiftUIView: View {
    let fileName: String
    
    var body: some View {
        if let fileUrl = Bundle.main.url(forResource: fileName, withExtension: "pdf") {
            PDFViewer(url: fileUrl)
                .edgesIgnoringSafeArea(.all)
                .navigationBarTitle("\(fileName).pdf", displayMode: .inline)
        } else {
            VStack {
                Image(systemName: "folder.badge.questionmark")
                Text("File does not exist")
            }
        }
    }
}

#Preview {
    PDFSwiftUIView(fileName: "Sample")
}
