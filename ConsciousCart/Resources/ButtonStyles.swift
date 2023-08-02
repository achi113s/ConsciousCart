//
//  ButtonStyles.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/2/23.
//

import SwiftUI

struct CCButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 7, leading: 12, bottom: 7, trailing: 12))
            .background(configuration.isPressed ? Color(white: 0.8) : .white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 10).stroke(style: .init(lineWidth: 1))
                    .fill(Color.init(white: 0.9))
            )
            .font(Font.custom("Nunito-Semibold", size: 17))
    }
}
