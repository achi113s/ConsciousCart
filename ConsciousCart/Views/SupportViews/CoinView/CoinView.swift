//
//  CoinView.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/28/23.
//

import CoreMotion
import SwiftUI

struct CoinView: View {
    @State private var coinSize: CGFloat = 100
    // diameter in points, all dimensions based on this
    // so everything scales correctly if you want to make the coin bigger.
    let dollarSignSize: CGFloat = 0.75
    let edgeWidth: CGFloat = 0.1
    let sparkleSize: CGFloat = 0.15
    let shine1Offset: CGFloat = 0.1
    let shine2Offset: CGFloat = 0.0
    let shineWidth: CGFloat = 0.1
    
    @State private var baseColor: Color
    @State private var secondaryColor: Color
    
    @StateObject private var motionManager = MotionManager()
    let motionStrength: CGFloat = 0.05
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(baseColor)
                .frame(width: coinSize)
            
            Circle()
                .foregroundColor(secondaryColor)
                .frame(width: coinSize - (coinSize * edgeWidth))
            
            Text("$")
                .font(.custom("Nunito-Bold", size: dollarSignSize * coinSize))
                .foregroundColor(baseColor)
            
            Rectangle()
                .frame(width: shineWidth * coinSize, height: coinSize * 1.1)
                .rotationEffect(Angle(degrees: 45))
                .offset(
                    x: -((shine1Offset * coinSize) + (motionManager.x * motionStrength * coinSize)),
                    y: -((shine1Offset * coinSize) + (motionManager.y * motionStrength * coinSize))
                )
                .mask {
                    Circle()
                        .foregroundColor(secondaryColor)
                        .frame(width: coinSize)
                }
                .foregroundColor(Color.init(white: 0.9, opacity: 0.3))
            
            Rectangle()
                .frame(width: shineWidth * coinSize, height: coinSize * 1.1)
                .rotationEffect(Angle(degrees: 45))
                .offset(
                    x: -((shine2Offset * coinSize) + (motionManager.x * motionStrength * coinSize)),
                    y: -((shine2Offset * coinSize) + (motionManager.y * motionStrength * coinSize))
                )
                .mask {
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: coinSize)
                }
                .foregroundColor(Color.init(white: 0.9, opacity: 0.3))
            
            Sparkle()
                .frame(width: sparkleSize * coinSize, height: sparkleSize * coinSize * 1.2)
                .offset(
                    x: -((coinSize * 0.25) + (motionManager.x * motionStrength * coinSize)),
                    y: -((coinSize * 0.2) + (motionManager.y * motionStrength * coinSize))
                )
                .foregroundColor(Color.init(white: 0.96, opacity: 0.5))
            
            Sparkle()
                .frame(width: sparkleSize * coinSize, height: sparkleSize * coinSize * 1.2)
                .offset(
                    x: ((coinSize * 0.25) - (motionManager.x * motionStrength * coinSize)),
                    y: ((coinSize * 0.1) - (motionManager.y * motionStrength * coinSize))
                )
                .foregroundColor(Color.init(white: 0.96, opacity: 0.5))
        }
        .mask {
            Circle()
                .foregroundColor(.white)
                .frame(width: coinSize)
        }
        .onAppear {
            if !motionManager.isMotionActive() {
                motionManager.startMotionUpdates()
            }
        }
        .onDisappear {
            if motionManager.isMotionActive() {
                motionManager.stopMotionUpdates()
            }
        }
    }
    
    init(coinSize: CGFloat, userLevel: UserLevel) {
        self.coinSize = coinSize
        
        switch userLevel {
        case .beginner:
            self.baseColor = Color(red: 121/255, green: 85/255, blue: 80/255)  // Soil
            self.secondaryColor = Color(red: 179/255, green: 146/255, blue: 134/255)  // Spoiled Chocolate
        case .saver:
            self.baseColor = Color(red: 128/255, green: 142/255, blue: 155/255)  // London Square
            self.secondaryColor = Color(red: 210/255, green: 218/255, blue: 226/255) // Hint of Elusive Blue
        case .superSaver:
            self.baseColor = Color(red: 247/255, green: 183/255, blue: 49/255)  // NYC Taxi
            self.secondaryColor = Color(red: 255/255, green: 221/255, blue: 89/255)  // Yriel Yellow
        case .ultimateSaver:
            self.baseColor = Color(red: 199/255, green: 236/255, blue: 238/255, opacity: 0.8)  // Hint of Ice
            self.secondaryColor = Color(red: 130/255, green: 204/255, blue: 221/255, opacity: 0.8)  // Spray
        }
    }
}

struct CoinView_Previews: PreviewProvider {
    static let coinSize: CGFloat = 300
    
    static var previews: some View {
        CoinView(coinSize: coinSize, userLevel: .ultimateSaver)
    }
}

