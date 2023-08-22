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
    I want to thank my friends and family for their unwavering support, \
    without whom this app wouldn't exist.
    """
    
    let madeWithLove: String = """
    Made with ❤️‍🔥 by
    """
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            HStack(spacing: 4) {
                Text(madeWithLove)
                    .multilineTextAlignment(.center)
                    .font(Font.custom("Nunito-Semibold", size: 17))
                Link("@giorgio_latour", destination: URL(string: "https://twitter.com/giorgio_latour")!)
                    .font(Font.custom("Nunito-Semibold", size: 17))
                    .foregroundColor(.blue)
            }
            
            Text(aboutText)
                .multilineTextAlignment(.center)
                .font(Font.custom("Nunito-Semibold", size: 17))
                .padding()
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
