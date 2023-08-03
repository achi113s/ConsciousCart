//
//  StatefulPreviewWrapper.swift
//  CustomColorPicker
//
//

import SwiftUI

// By Jim Dovey
// https://developer.apple.com/forums/thread/118589
// Part of his SwiftUI toolkit, available here:
// https://github.com/AlanQuatermain/AQUI
struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content

    var body: some View {
        content($value)
    }

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        self._value = State(wrappedValue: value)
        self.content = content
    }
}
