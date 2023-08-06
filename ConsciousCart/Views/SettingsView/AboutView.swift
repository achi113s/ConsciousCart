//
//  AboutView.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/8/23.
//

import SwiftUI

struct AboutView: View {
    let aboutText: String = """
    ConsciousCart is my first official iOS app! \
    I'm a self-taught iOS Engineer who has a background in physics. The idea for \
    this app came from my own experience practicing delayed \
    gratification to curb regretful spending. \n
    I want to thank my friends and family for their unwavering support. \
    Without them this wouldn't be possible.
    """
    var body: some View {
        VStack(alignment: .center, spacing: 50) {
            Text(aboutText)
                .multilineTextAlignment(.center)
                .font(Font.custom("Nunito-Semibold", size: 17))
            Text("💡")
                .font(.system(size: 50))
        }
        .padding()
        .navigationTitle("About")
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
