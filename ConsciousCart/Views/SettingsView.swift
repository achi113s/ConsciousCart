//
//  NewSettingsView.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/8/23.
//

import SwiftUI

struct SettingsView: View {
    var impulsesStateManager: ImpulsesStateManager?
    
    @State private var showingDeleteAlert = false
    @State private var forceDarkModeSetting = UserDefaults.standard.bool(forKey: UserDefaultsKeys.forceDarkModeSetting.rawValue)
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    VStack(alignment: .leading) {
                        SectionLabel(text: "About")
                        
                        NavigationLink {
                            AboutView()
                        } label: {
                            HStack {
                                Text("📒  About ConsciousCart")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color.init(white: 0.6))
                            }
                            .frame(height: 30)
                        }
                        .modifier(CCButton())
                        
                        Button {
                            
                        } label: {
                            HStack {
                                Text("📧  Share Feedback")
                                Spacer()
                                Image(systemName: "arrow.up.forward")
                                    .foregroundColor(Color.init(white: 0.6))
                            }
                            .frame(height: 30)
                        }
                        .modifier(CCButton())
                        
                        Button {
                            
                        } label: {
                            HStack {
                                Text("💫  Rate ConsciousCart!")
                                Spacer()
                                Image(systemName: "arrow.up.forward")
                                    .foregroundColor(Color.init(white: 0.6))
                            }
                            .frame(height: 30)
                        }
                        .modifier(CCButton())
                        
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        SectionLabel(text: "Appearance")
                        
                        Toggle("🌙  Dark Mode", isOn: $forceDarkModeSetting)
                            .onChange(of: forceDarkModeSetting) { darkModeEnabled in
                                UserDefaults.standard.set(forceDarkModeSetting, forKey: UserDefaultsKeys.forceDarkModeSetting.rawValue)
                            }
                            .strikethrough()
                            .frame(height: 40)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 20))
                            .background(.white)
                            .tint(.green)
                            .cornerRadius(8)
                            .foregroundColor(.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(style: .init(lineWidth: 1))
                                    .fill(Color.init(white: 0.8))
                            )
                            .font(Font.custom("Nunito-Semibold", size: 17))
                        
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        SectionLabel(text: "My Data")
                        
                        Button(role: .destructive) {
                            showingDeleteAlert = true
                        } label: {
                            HStack {
                                Text("🗑️  Delete My Data")
                                    .foregroundColor(.red)
                                Spacer()
                            }
                            .frame(height: 30)
                        }
                        .alert("Delete My Data", isPresented: $showingDeleteAlert) {
                            Button("Cancel", role: .cancel) { }
                            Button("Delete", role: .destructive) {
                                impulsesStateManager?.deleteAllImpulses()
                            }
                        } message: {
                            Text("Are you sure you want to permanently delete all of your Impulses? This action cannot be undone.")
                        }
                        .modifier(CCButton())
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .scrollContentBackground(.hidden)
        .tint(.black)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(impulsesStateManager: nil)
    }
}

struct SectionLabel: View {
    let text: String
    var body: some View {
        Text(text.uppercased())
            .font(Font.custom("Nunito-Semibold", size: 13))
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
            .foregroundColor(.secondary)
    }
    
    init(text: String) {
        self.text = text
    }
}

struct CCButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(.borderedProminent)
            .tint(.white)
            .foregroundColor(.black)
            .overlay(
                RoundedRectangle(cornerRadius: 8).stroke(style: .init(lineWidth: 1))
                    .fill(Color.init(white: 0.8))
            )
            .font(Font.custom("Nunito-Semibold", size: 17))
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(
                withAnimation {
                    configuration.isPressed ? 1.03 : 1
                }
            )
        
    }
}
