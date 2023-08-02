//
//  NewSettingsView.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/8/23.
//

import SwiftUI

struct SettingsView: View {
    var impulsesStateManager: ImpulsesStateManager? = nil
    
    @State private var showingDeleteAlert = false
    @State private var showingAccentResetAlert = false
    //    @State private var forceDarkModeSetting = UserDefaults.standard.bool(forKey: UserDefaultsKeys.forceDarkModeSetting.rawValue)
    @State private var accentColorSetting: Color = Color(
        uiColor: UserDefaults.standard.color(forKey: UserDefaultsKeys.accentColor.rawValue) ?? UIColor(named: "ShyMoment")!)
    
    @State private var userNameField: String = ""
    @State private var showUserNameMessage: Bool = false
    @State private var userNameMessage: String = ""
    @State private var userNameError: Bool = false
    
    let spacingToSectionLabel: CGFloat = 8
    let interButtonSpacing: CGFloat = 12
    let interGroupSpacing: CGFloat = 25
    
    let deleteMessage: String = """
        Are you sure you want to permanently delete all of
        your Impulses and settings? This action cannot be undone.
    """
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: interGroupSpacing) {
                    VStack(alignment: .leading, spacing: interButtonSpacing) {
                        VStack(alignment: .leading, spacing: spacingToSectionLabel) {
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
                            .buttonStyle(CCButtonStyle())
                        }
                        
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
                        .buttonStyle(CCButtonStyle())
                        
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
                        .buttonStyle(CCButtonStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: interButtonSpacing) {
                        VStack(alignment: .leading, spacing: spacingToSectionLabel) {
                            SectionLabel(text: "Appearance")
                            
                            ColorPicker("🎨  Accent Color", selection: $accentColorSetting, supportsOpacity: false)
                                .onChange(of: accentColorSetting, perform: { newColor in
                                    let uiColor = UIColor(newColor)
                                    UserDefaults.standard.set(uiColor, forKey: UserDefaultsKeys.accentColor.rawValue)
                                })
                                .frame(height: 40)
                                .padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 25))
                                .background(.white)
                                .cornerRadius(8)
                                .foregroundColor(.black)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(style: .init(lineWidth: 1))
                                        .fill(Color.init(white: 0.9))
                                )
                                .font(Font.custom("Nunito-Semibold", size: 17))
                        }
                        Button {
                            showingAccentResetAlert = true
                        } label: {
                            HStack {
                                Text("🪄  Reset Accent Color")
                                Spacer()
                            }
                            .frame(height: 30)
                        }
                        .buttonStyle(CCButtonStyle())
                        .alert("Reset Accent Color", isPresented: $showingAccentResetAlert) {
                            Button("Cancel", role: .cancel) { }
                            Button("Reset") {
                                UserDefaults.standard.set(UIColor(named: "ShyMoment"), forKey: UserDefaultsKeys.accentColor.rawValue)
                                accentColorSetting = Color("ShyMoment")
                            }
                        } message: {
                            Text("Are you sure you want to reset the app's accent color to its default value? This action cannot be undone.")
                        }
                    }
                    
                    
                    VStack(alignment: .leading, spacing: spacingToSectionLabel) {
                        SectionLabel(text: "My Info")
                        
                        HStack {
                            TextField("Change Username", text: $userNameField, prompt: Text("Change your username."))
                                .frame(height: 30)
                                .padding(EdgeInsets(top: 7, leading: 12, bottom: 7, trailing: 12))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10).stroke(style: .init(lineWidth: 1))
                                        .fill(Color.init(white: 0.9))
                                )
                                .font(Font.custom("Nunito-Semibold", size: 17))
                            
                            Button {
                                checkUserNameInput(userNameField)
                            } label: {
                                HStack {
                                    Text("Save")
                                }
                                .frame(height: 30)
                            }
                            .buttonStyle(CCButtonStyle())
                        }
                        
                        if showUserNameMessage {
                            Text("\(userNameMessage)")
                                .font(Font.custom("Nunito-Semibold", size: 12))
                                .foregroundColor(userNameError ? .red : .primary)
                                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                                .transition(AnyTransition.opacity)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: spacingToSectionLabel) {
                        SectionLabel(text: "My Data")
                        
                        Button(role: .destructive) {
                            showingDeleteAlert = true
                        } label: {
                            HStack {
                                Text("💣  Delete My Data")
                                    .foregroundColor(.red)
                                Spacer()
                            }
                            .frame(height: 30)
                        }
                        .alert("Delete My Data", isPresented: $showingDeleteAlert) {
                            Button("Cancel", role: .cancel) { }
                            Button("Delete", role: .destructive) {
                                impulsesStateManager?.deleteAllImpulses()
                                //                                impulsesStateManager?.deleteUser()
                                Utils.resetUserDefaults()
                            }
                        } message: {
                            Text(deleteMessage)
                        }
                        .buttonStyle(CCButtonStyle())
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .scrollContentBackground(.hidden)
        .tint(.black)
    }
    
    init(impulsesStateManager: ImpulsesStateManager?) {
        self.impulsesStateManager = impulsesStateManager
        
        if let impulsesStateManager = impulsesStateManager {
            let fillText = impulsesStateManager.userStats?.unwrappedUserName ?? ""
        }
    }
    
    private func checkUserNameInput(_ newUserName: String) {
        // Username Requirements
        // - Only letters and numbers.
        // - Length must be between 3 and 10 characters.
        
        let trimmed = newUserName.trimmingCharacters(in: .whitespacesAndNewlines)
        let userNameContainsInvalidChars = !trimmed.isAlphanumeric()
        let userNameLengthBad = trimmed.count > 10 || trimmed.count < 3
        
        withAnimation {
            if !userNameContainsInvalidChars && !userNameLengthBad {
                saveNewUsername(trimmed)
            } else if userNameContainsInvalidChars && !userNameLengthBad {
                showUserNameMessage = true
                userNameError = true
                userNameMessage = UserNameMessage.userNameCanOnlyHaveLettersOrNums.rawValue
            } else if userNameLengthBad && !userNameContainsInvalidChars {
                showUserNameMessage = true
                userNameError = true
                userNameMessage = UserNameMessage.userNameTooShortOrLong.rawValue
            } else {
                showUserNameMessage = true
                userNameError = true
                userNameMessage = UserNameMessage.userNameLengthAndCharsBad.rawValue
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    showUserNameMessage = false
                    userNameError = false
                }
            }
        }
    }
    
    private func saveNewUsername(_ newUserName: String) {
        guard let impulsesStateManager = impulsesStateManager else { return }
        
        impulsesStateManager.updateUserName(to: newUserName)
        
        showUserNameMessage = true
        userNameError = false
        userNameMessage = UserNameMessage.userNameGood.rawValue
    }
    
    private enum UserNameMessage: String {
        case userNameGood = "Username Saved"
        case userNameTooShortOrLong = "Username must be between 3 and 10 characters."
        case userNameCanOnlyHaveLettersOrNums = "Usernames can only contain letters and numbers."
        case userNameLengthAndCharsBad = "Username must be between 3 and 10 character and can only contain letters and numbers."
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(impulsesStateManager: nil)
    }
}
