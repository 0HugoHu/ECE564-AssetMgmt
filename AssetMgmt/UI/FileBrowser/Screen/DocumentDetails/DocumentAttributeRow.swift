//
//  DocumentAttributeRow.swift
//  AssetMgmt
//
//  Created by Minghui ZHU on 11/23/23.
//

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
