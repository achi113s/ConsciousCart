//
//  SettingsView.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 5/19/23.
//

import CoreData
import SwiftUI

struct SettingsView: View {
//    var impulsesStateManager: ImpulsesStateManager?
    
    @State private var showingDeleteAlert = false
    @State private var forceDarkModeSetting = UserDefaults.standard.bool(forKey: UserDefaultsKeys.forceDarkModeSetting.rawValue)
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Section("About") {
                    Button() {
                        
                    } label: {
                        Text("📒  About ConsciousCart")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
        //        List {
        //            Section("About") {
        //                Group {
        //                    Button() {
        //
        //                    } label: {
        //                        Text("📒  About ConsciousCart")
        //                    }
        //
        //                    Button() {
        //
        //                    } label: {
        //                        HStack {
        //                            Text("📧  Share Feedback")
        //                            Spacer()
        //                            Image(systemName: "arrow.up.forward")
        //                        }
        //                    }
        //
        //                    Button() {
        //
        //                    } label: {
        //                        HStack {
        //                            Text("💫  Rate ConsciousCart!")
        //                            Spacer()
        //                            Image(systemName: "arrow.up.forward")
        //                        }
        //                    }
        //                }
        //                .font(Font.custom("Nunito-Semibold", size: 17))
        //                .foregroundColor(.black)
        //            }
        //            .font(Font.custom("Nunito-Semibold", size: 13))
        //
        //            Section("Appearance") {
        //                VStack {
        //                    Toggle("🌙  Dark Mode", isOn: $forceDarkModeSetting)
        //                        .onChange(of: forceDarkModeSetting) { darkModeEnabled in
        //                            UserDefaults.standard.set(forceDarkModeSetting, forKey: UserDefaultsKeys.forceDarkModeSetting.rawValue)
        //                        }
        //                }
        //                .font(Font.custom("Nunito-Semibold", size: 17))
        //            }
        //            .font(Font.custom("Nunito-Semibold", size: 13))
        //
        //            Section("My Data") {
        //                VStack {
        //                    Button("Delete My Data", role: .destructive) {
        //                        showingDeleteAlert = true
        //                    }
        //                    .alert("Delete My Data", isPresented: $showingDeleteAlert) {
        //                        Button("Cancel", role: .cancel) { }
        //                        Button("Delete", role: .destructive) {
        //                            impulsesStateManager?.deleteAllImpulses()
        //                        }
        //                    } message: {
        //                        Text("Are you sure you want to permanently delete all of your Impulses? This action cannot be undone.")
        //                    }
        //
        //                }
        //                .font(Font.custom("Nunito-Semibold", size: 17))
        //            }
        //            .font(Font.custom("Nunito-Semibold", size: 13))
        //        }
        //        .listStyle(.insetGrouped)
        //    }
    }

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
