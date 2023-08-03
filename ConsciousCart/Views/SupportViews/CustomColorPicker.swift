//
//  CustomColorPicker.swift
//  CustomColorPicker
//
//  Created by Giorgio Latour on 8/2/23.
//

import SwiftUI

struct CustomColorPicker<ColorShape: Shape>: View {
    var title: String
    var colorShapeSize: CGSize
    var colorShape: ColorShape
    
    @State private var colors: [Color]
    @Binding private var selectedColor: Color
    
    var body: some View {
        HStack {
            Text("\(title)")
            
            Spacer()
            
            ForEach(colors, id: \.hashValue) { color in
                colorShape
                    .fill(color)
                    .frame(width: colorShapeSize.width, height: colorShapeSize.height)
                    .overlay {
                        if selectedColor == color {
                            colorShape
                                .scale(1.3)
                                .stroke(style: .init(lineWidth: 2))
                        }
                    }
                    .onTapGesture {
                        selectedColor = color
                    }
            }
        }
    }
    
    init(title: String,
         colors: [Color],
         selectedColor: Binding<Color>,
         colorShapeSize: CGSize,
         colorShape: @escaping () -> ColorShape = { Circle() }
    ) {
        self.title = title
        self._colors = State(initialValue: colors)
        self._selectedColor = selectedColor
        self.colorShape = colorShape()
        self.colorShapeSize = colorShapeSize
    }
}

struct CustomColorPicker_Previews: PreviewProvider {
    static let title = "🎨  Accent Color"
    static let colors: [Color] = [.red, .blue, .green, Color("ShyMoment")]
    static let defaultSelectedColor: Color = .red
    
    static var previews: some View {
        StatefulPreviewWrapper(Color.red) {
            CustomColorPicker(title: title, colors: colors, selectedColor: $0, colorShapeSize: CGSize(width: 20, height: 20))
        }
    }
}
