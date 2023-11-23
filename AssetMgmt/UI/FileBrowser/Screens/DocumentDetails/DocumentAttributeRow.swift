import SwiftUI

struct DocumentAttributeRow: View {
    var key: String
    var value: String?
    var values: [String]?

    init(key: String, value: String) {
        self.key = key
        self.value = value
        self.values = nil
    }

    init(key: String, values: [String]) {
        self.key = key
        self.value = nil
        self.values = values
    }

    var body: some View {
        HStack {
            Text(key)
            Spacer()
            if let value = value {
                Text(value)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.secondary)
            } else if let values = values {
                HStack {
                    ForEach(values, id: \.self) { value in
                        Text(value)
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.tertiarySystemFill))
                            )
                    }
                }
                .multilineTextAlignment(.trailing)
                .foregroundColor(.secondary)
            }
        }
    }
}

//// Preview for a single value
//struct DocumentAttributeRow_SingleValue_Previews: PreviewProvider {
//    static var previews: some View {
//        DocumentAttributeRow(key: "Size", value: "2.3 MB").padding()
//    }
//}

// Preview for multiple values with potential overflow
struct DocumentAttributeRow_MultipleValues_Previews: PreviewProvider {
    static var previews: some View {
        DocumentAttributeRow(key: "Contributors", values: ["Person A", "Person B", "Person C", "Person D", "Person E", "Person F"]).padding()
    }
}
