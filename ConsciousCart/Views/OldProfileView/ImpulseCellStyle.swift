//
//  ImpulseCellContent.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/3/23.
//

import SwiftUI

struct ImpulseCellStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
            .background(configuration.isPressed ? Color(white: 0.8) : .white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10).stroke(style: .init(lineWidth: 1))
                    .fill(Color.init(white: 0.9))
            )
    }
}
