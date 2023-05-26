//
//  TextViewAnimatableNumber.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 5/22/23.
//

import SwiftUI

struct TextViewAnimatableNumber: View, Animatable {
    var number: Double
    
    var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter
    }()
    
    var animatableData: Double {
        get { number }
        set { number = newValue }
    }
    
    var body: some View {
        Text(formatter.string(for: number) ?? "")
    }
}
