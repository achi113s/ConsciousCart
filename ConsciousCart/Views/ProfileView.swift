//
//  ProfileView.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/27/23.
//

import SwiftUI

struct ProfileView: View {
    var impulsesStateManager: ImpulsesStateManager? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    Text("Hello, world!")
                    Image(systemName: "heart.fill")
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
        .scrollContentBackground(.hidden)
        .tint(.black)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
