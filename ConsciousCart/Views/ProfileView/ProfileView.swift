//
//  ProfileView.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/27/23.
//

import SwiftUI

struct ProfileView: View {
    @FetchRequest(entity: Impulse.entity(), sortDescriptors: []) var impulses: FetchedResults<Impulse>
    @FetchRequest(entity: UserStats.entity(), sortDescriptors: []) var userStats: FetchedResults<UserStats>
    
    var impulsesStateManager: ImpulsesStateManager! = nil
    
    var score: Double {
        userStats.first?.totalAmountSaved ?? 0.0
    }

    var userLevel: UserLevel {
        guard let userStats = userStats.first else { return .beginner }
        
        switch userStats.level {
        case 0:
            return UserLevel.beginner
        case 1:
            return UserLevel.saver
        case 2:
            return UserLevel.superSaver
        case 3:
            return UserLevel.ultimateSaver
        default:
            return UserLevel.beginner
        }
    }
    
    var pendingImpulsesCount: Int {
        impulses.filter { !$0.completed && ($0.unwrappedRemindDate < Date.now)}.count
    }
    
    var userName: String {
        userStats.first?.userName ?? "NoName"
    }
    
    var scoreMessage: String {
        if score == 0.0 { return "Either you haven't spent any money, or you broke even..." }
        
        return score < 0.0 ? "Yikes, you've spent" : "Nice job \(userName), you've saved"
    }
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 20) {
                        CoinView(coinSize: 125, userLevel: userLevel)
                        
                        VStack {
                            Text(scoreMessage)
                                .multilineTextAlignment(.center)
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
                    
                    VStack(alignment: .leading) {
                        SectionLabel(text: "My Impulses")
                        
                        NavigationLink {
                            ImpulsesView(filter: .active, impulsesStateManager: impulsesStateManager)
                        } label: {
                            HStack {
                                Text("🛍️  Active Impulses")
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color.init(white: 0.6))
                            }
                            .frame(height: 30)
                        }
                        .buttonStyle(CCButtonStyle())
                        
                        NavigationLink {
                            ImpulsesView(filter: .pending, impulsesStateManager: impulsesStateManager)
                        } label: {
                            HStack {
                                Text("⏱️  Pending Impulses")
                                
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
                        
                        NavigationLink {
                            ImpulsesView(filter: .completed, impulsesStateManager: impulsesStateManager)
                        } label: {
                            HStack {
                                Text("✅  Completed Impulses")
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color.init(white: 0.6))
                            }
                            .frame(height: 30)
                        }
                        .buttonStyle(CCButtonStyle())
                    }
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
    
    init(impulsesStateManager: ImpulsesStateManager) {
        self.impulsesStateManager = impulsesStateManager
    }
    
    private func redOrGreen(for savedAmount: Double) -> Color {
        savedAmount >= 0.0 ? .green : .red
    }
}
