//
//  SettingsView.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 5/19/23.
//

import CoreData
import SwiftUI

struct SettingsView: View {
    var impulsesStateManager: ImpulsesStateManager?
    
    @State private var showingDeleteAlert = false
    @State private var forceDarkModeSetting = UserDefaults.standard.bool(forKey: UserDefaultsKeys.forceDarkModeSetting.rawValue)
    
    var body: some View {
        List {
            Section("Appearance") {
                VStack {
                    Toggle("Dark Mode", isOn: $forceDarkModeSetting)
                        .onChange(of: forceDarkModeSetting) { darkModeEnabled in
                            UserDefaults.standard.set(forceDarkModeSetting, forKey: UserDefaultsKeys.forceDarkModeSetting.rawValue)
                        }
                }
                .font()
            }
            
            Section("My Data") {
                VStack {
                    Button("Delete My Data", role: .destructive) {
                        showingDeleteAlert = true
                    }
                    .alert("Delete My Data", isPresented: $showingDeleteAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Delete", role: .destructive) {
                            impulsesStateManager?.deleteAllImpulses()
                        }
                    } message: {
                        Text("Are you sure you want to permanently delete all of your Impulses? This action cannot be undone.")
                    }
                    
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}
