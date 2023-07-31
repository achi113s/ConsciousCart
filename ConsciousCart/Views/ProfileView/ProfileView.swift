//
//  ProfileView.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/27/23.
//

import SwiftUI

struct ProfileView: View {
    //    var impulsesStateManager: ImpulsesStateManager? = nil
    @FetchRequest(entity: Impulse.entity(), sortDescriptors: []) var impulses: FetchedResults<Impulse>
    @FetchRequest(entity: UserStats.entity(), sortDescriptors: []) var userStats: FetchedResults<UserStats>
    
    //    var score: Double {
    //        return impulses.filter { $0.completed }.reduce(0.0) { $0 + $1.amountSaved }
    ////        let totalSaved: Double = impulsesStateManager?.totalAmountSaved ?? 0.0
    ////        scoreMessage = totalSaved < 0.0 ? "You've spent" : "You've saved"
    ////        return score
    //    }
    
    var score: Double {
        userStats.first?.totalAmountSaved ?? 0.0
    }
    
    var userLevel: UserLevel {
        let level: Int16 = userStats.first?.level ?? 0
        
        switch level {
        case 0:
            return .beginner
        case 1:
            return .saver
        case 2:
            return .superSaver
        case 3:
            return .ultimateSaver
        default:
            return .beginner
        }
    }
    
    var pendingImpulsesCount: Int {
        impulses.filter { !$0.completed && ($0.unwrappedRemindDate < Date.now)}.count
    }
    
    var scoreMessage: String {
        score < 0.0 ? "You've spent" : "You've saved"
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
                            ImpulsesView(filter: .active)
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
                            ImpulsesView(filter: .pending)
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
                            ImpulsesView(filter: .completed)
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
    
    private func redOrGreen(for savedAmount: Double) -> Color {
        savedAmount >= 0.0 ? .green : .red
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
