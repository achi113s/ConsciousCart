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
            .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
            .background(configuration.isPressed ? Color(white: 0.8) : .white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(style: .init(lineWidth: 1))
                    .fill(Color.init(white: 0.9))
            )
            .font(Font.custom("Nunito-Semibold", size: 17))
    }
}

// Use this to apply the same style as above, but to non-button items.
struct CCSettingModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
            .background(.white)
            .cornerRadius(8)
            .foregroundColor(.black)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(style: .init(lineWidth: 1))
                    .fill(Color.init(white: 0.9))
            )
            .font(Font.custom("Nunito-Semibold", size: 17))
    }
}
