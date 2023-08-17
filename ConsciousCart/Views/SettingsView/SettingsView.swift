//
//  NewSettingsView.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/8/23.
//

import MessageUI
import SwiftUI

struct SettingsView: View {
    var impulsesStateManager: ImpulsesStateManager? = nil
    
    @State private var showingDeleteAlert = false
    @State private var showingAccentResetAlert = false
    @State private var selectedAccentColor: String = UserDefaults.standard.string(forKey: UserDefaultsKeys.accentColor.rawValue) ?? "ShyMoment"
    
    @State private var allowHaptics: Bool = UserDefaults.standard.bool(forKey: UserDefaultsKeys.allowHaptics.rawValue)
    
    @State private var userNameField: String = ""
    @FocusState private var userNameFieldFocused: Bool
    @State private var showUserNameMessage: Bool = false
    @State private var userNameMessage: String = ""
    @State private var userNameError: Bool = false
    
    // Send Email
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    @State var showingMailError = false
    
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
                                    CustomChevron()
                                }
                                .frame(height: 30)
                            }
                            .buttonStyle(CCButtonStyle())
                        }
                        
                        Button {
                            if MFMailComposeViewController.canSendMail() {
                                isShowingMailView.toggle()
                            } else {
                                showingMailError.toggle()
                            }
                        } label: {
                            HStack {
                                Text("📧  Share Feedback")
                                Spacer()
                                Image(systemName: "arrow.up.forward")
                                    .foregroundColor(Color.init(white: 0.7))
                                    .font(.system(size: 12, weight: .bold))
                            }
                            .frame(height: 30)
                        }
                        .buttonStyle(CCButtonStyle())
                        .sheet(isPresented: $isShowingMailView) {
                            MailView(result: self.$result)
                        }
                        .alert("Cannot send mail.", isPresented: $showingMailError) {
                            Button("OK") { }
                        } message: {
                            Text("Unable to send email from this device. It may be that you are not using the default Mail app.")
                        }

                        Button {
                            
                        } label: {
                            HStack {
                                Text("💫  Rate ConsciousCart!")
                                Spacer()
                                Image(systemName: "arrow.up.forward")
                                    .foregroundColor(Color.init(white: 0.7))
                                    .font(.system(size: 12, weight: .bold))
                            }
                            .frame(height: 30)
                        }
                        .buttonStyle(CCButtonStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: interButtonSpacing) {
                        VStack(alignment: .leading, spacing: spacingToSectionLabel) {
                            SectionLabel(text: "Effects")
                            
                            Toggle("🫨  Allow Haptics", isOn: $allowHaptics)
                                .tint(.green)
                                .onChange(of: allowHaptics, perform: { newValue in
                                    UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.allowHaptics.rawValue)
                                    print("allowHaptics set to \(UserDefaults.standard.bool(forKey: UserDefaultsKeys.allowHaptics.rawValue))")
                                })
                                .frame(height: 30)
                                .modifier(CCSettingModifier())
                            
                        }
                    }
                    
                    // Two VStacks for one element because there is currently only
                    // one element in this section now. So the first VStack is not
                    // necessary but there for consistency.
                    VStack(alignment: .leading, spacing: interButtonSpacing) {
                        VStack(alignment: .leading, spacing: spacingToSectionLabel) {
                            SectionLabel(text: "Appearance")
                            
                            CustomColorPicker("🎨  Accent Color",
                                              colors: ["ShyMoment", "Yriel", "Soil", "DarkMountainMeadow", "ElectronBlue"],
                                              selectedColor: $selectedAccentColor,
                                              colorShapeSize: CGSize(width: 20, height: 20)
                            )
                            .onChange(of: selectedAccentColor, perform: { newColor in
                                UserDefaults.standard.set(newColor, forKey: UserDefaultsKeys.accentColor.rawValue)
                            })
                            .frame(height: 30)
                            .modifier(CCSettingModifier())
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
                                .focused($userNameFieldFocused)
                            
                            Button {
                                checkUserNameInput(userNameField)
                                userNameFieldFocused = false
                            } label: {
                                HStack {
                                    Text("Save")
                                }
                                .frame(height: 34)
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
                                impulsesStateManager?.deleteUser()
                                impulsesStateManager?.saveImpulses()
                                impulsesStateManager?.saveUserStats()
                                
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
            .onTapGesture {
                userNameFieldFocused = false
            }
        }
        .scrollContentBackground(.hidden)
        .tint(.black)
    }
    
    init(impulsesStateManager: ImpulsesStateManager?) {
        self.impulsesStateManager = impulsesStateManager
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
        impulsesStateManager.saveUserStats()
        
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
