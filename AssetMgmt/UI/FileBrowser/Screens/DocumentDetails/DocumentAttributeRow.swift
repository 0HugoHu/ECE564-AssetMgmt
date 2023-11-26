import SwiftUI

struct DocumentAttributeRow: View {
    var key: String
    var value: String?

    init(key: String, value: String) {
        self.key = key
        self.value = value
    }

    var body: some View {
        HStack {
            Text(key)
            Spacer()
            if let value = value {
                Text(value)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// Preview for a single value
struct DocumentAttributeRow_SingleValue_Previews: PreviewProvider {
    static var previews: some View {
        DocumentAttributeRow(key: "Size", value: "2.3 MB").padding()
    }
}

