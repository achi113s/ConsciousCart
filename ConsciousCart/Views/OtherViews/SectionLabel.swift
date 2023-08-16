//
//  SectionLabel.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/2/23.
//

import SwiftUI

struct SectionLabel: View {
    let text: String
    var body: some View {
        Text(text.uppercased())
            .font(Font.custom("Nunito-Semibold", size: 13))
            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
            .foregroundColor(.secondary)
    }
    
    init(text: String) {
        self.text = text
    }
}
