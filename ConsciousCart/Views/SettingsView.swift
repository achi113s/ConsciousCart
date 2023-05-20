//
//  SettingsView.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 5/19/23.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var settingsItems = ["Settings1", "Settings2"]
    
    var body: some View {
        VStack {
            Form {
                Section {
                    ForEach(settingsItems, id: \.self) { item in
                        Text(item)
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
