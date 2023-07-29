//
//  ProfileView.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/27/23.
//

import SwiftUI

struct ProfileView: View {
    var impulsesStateManager: ImpulsesStateManager? = nil
    
    @State private var scoreMessage: String = ""
    @State private var score: Double = 0.0
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
    @State private var pendingImpulsesCount: Int = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    VStack(spacing: 20) {
                        CoinView(coinSize: 125, userLevel: (impulsesStateManager?.userLevel ?? .beginner))
                        
                        VStack {
                            Text(scoreMessage)
                                .font(Font.custom("Nunito-Bold", size: 18))
                                .foregroundColor(differentiateWithoutColor ? .primary : redOrGreen(for: score))
                            
                            TextViewAnimatableCurrency(number: score)
                                .font(Font.custom("Nunito-Bold", size: 42))
                                .lineLimit(0...1)
                                .foregroundColor(differentiateWithoutColor ? .primary : redOrGreen(for: score))
                                .minimumScaleFactor(0.5)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button {
                        print("df")
                    } label: {
                        HStack {
                            Text("⏰  Pending Impulses")
                            
                            Spacer()
                            
                            if pendingImpulsesCount != 0 {
                                Text("\(pendingImpulsesCount)")
                                    .font(Font.custom("Nunito-Bold", size: 17))
                                    .foregroundColor(.red)
                            }
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.init(white: 0.6))
                        }
                        .frame(height: 30)
                    }
                    .buttonStyle(CCButtonStyle())
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
        .scrollContentBackground(.hidden)
        .tint(.black)
        .onAppear {
            setScore()
            setPending()
        }
    }
    
    private func setScore() {
        let totalSaved: Double = impulsesStateManager?.totalAmountSaved ?? 0.0
        scoreMessage = totalSaved < 0.0 ? "You've spent" : "You've saved"
        score = totalSaved
    }
    
    private func setPending() {
        guard let impulsesStateManager = impulsesStateManager else { return }
        pendingImpulsesCount = impulsesStateManager.pendingImpulses.count
    }
    
    private func redOrGreen(for savedAmount: Double) -> Color {
        savedAmount >= 0.0 ? .green : .red
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
