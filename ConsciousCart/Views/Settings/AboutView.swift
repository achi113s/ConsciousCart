//
//  AboutView.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/8/23.
//

import SwiftUI

struct AboutView: View {
    let aboutText: String = """
        ConsciousCart is the first official iOS app developed by Giorgio Latour,
        a self-taught iOS Engineer who has a background in physics. The idea for
        the app comes from the developer's own experience practicing delayed
        gratification to curb regretful spending. \n
        The developer wishes to thank his parents for their unwavering support.
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
