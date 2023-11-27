import SwiftUI

struct DocumentAttributeRow: View {
    var key, value: String

    var body: some View {
        HStack {
            Text(key)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
                .foregroundColor(.secondary)
        }
    }
}
