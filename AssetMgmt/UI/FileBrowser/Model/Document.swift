import Foundation

struct Document: Identifiable {
    var id = UUID()
    
    var mediaBeaconID: Int = 0
    var name: String
    var url: URL
    var size: NSNumber
    var created: Date?
    var modified: Date?
    var highQualityPreviewUrl: String?
    var type: String = "unknown"
    
    var isDirectory: Bool = false
}

extension Document {
    var formattedSize: String {
        Int(truncating: size).formatted(ByteCountFormatStyle())
    }
}

extension Document: Equatable {
    static func == (lhs: Document, rhs: Document) -> Bool {
        lhs.id == rhs.id
    }
}

func convertToDocument(from assetInfo: AssetInfoResponse) -> Document {
    let name = assetInfo.name
    let mediaBeaconID = assetInfo.id
    let url = URL(string: assetInfo.path) ?? URL(fileURLWithPath: "") // Replace with a proper base URL if needed
    let size = NSNumber(value: assetInfo.bytes)
    
    // Convert lastModified to Date
    let modifiedDate = Date(timeIntervalSince1970: assetInfo.lastModified)
    
    // Extract high quality preview URL
    let highQualityPreviewUrl = assetInfo.previews.high

    // Determine the MIME type if available
    let type = assetInfo.mimeType ?? "unknown"

    // Creating and returning a Document instance
    return Document(mediaBeaconID: mediaBeaconID,
                    name: name,
                    url: url,
                    size: size,
                    created: nil, // If you have creation date info, use it here
                    modified: modifiedDate,
                    highQualityPreviewUrl: highQualityPreviewUrl,
                    type: type)
}
