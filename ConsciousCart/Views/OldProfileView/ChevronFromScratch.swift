//
//  ChevronFromScratch.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/3/23.
//

import SwiftUI

struct ChevronFromScratch: View {
    var body: some View {
        Image(systemName: "chevron.right")
            .foregroundColor(Color.init(white: 0.7))
            .font(.system(size: 12, weight: .bold))
    }
}

struct ChevronFromScratch_Previews: PreviewProvider {
    static var previews: some View {
        ChevronFromScratch()
    }
}
