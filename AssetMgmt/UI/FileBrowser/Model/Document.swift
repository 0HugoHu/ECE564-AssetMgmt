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
