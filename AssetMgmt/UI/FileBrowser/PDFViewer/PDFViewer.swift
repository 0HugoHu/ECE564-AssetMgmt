//
//  PDFViewer.swift
//  AssetMgmt
//
//  Created by Athenaost on 11/1/23.
//

import SwiftUI
import PDFKit

struct PDFViewer: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = PDFDocument(url: url)
    }
}

struct PDFViewer_Previews: PreviewProvider {
    static var previews: some View {
        // Make sure the URL string is correct and that the URL can be constructed
        if let url = URL(string: DOWNLOAD_URL_TEST) {
            PDFViewer(url: url)
                .preferredColorScheme(.light) // You can change this to .dark if you want to preview dark mode
                .previewDisplayName("PDF Viewer")
        } else {
            Text("Invalid URL for PDF document.")
        }
    }
}
