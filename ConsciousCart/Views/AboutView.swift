//
//  AboutView.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/8/23.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("ConsciousCart is the first official iOS app developed by Giorgio Latour, a self-taught iOS Engineer who has a background in physics. The idea for the app comes from Giorgio's own experience practicing delayed gratification to curb regretful spending.")
                .multilineTextAlignment(.center)
                .font(Font.custom("Nunito-Semibold", size: 17))
            Spacer()
            Spacer()
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
