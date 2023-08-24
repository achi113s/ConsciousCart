//
//  CoinView.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/28/23.
//

import CoreMotion
import SwiftUI

struct CoinView: View {
    @ObservedObject var coinViewModel: CoinViewModel
    private var coinSize: CGFloat = 100
    // diameter in points, all dimensions based on this
    // so everything scales correctly if you want to make the coin bigger.
    // maybe can make a small view model with userLevel that conforms to ObservableObject
    // have a public method which allows for changing the userLevel in viewWillAppear of the
    // ProfileViewController
    
    let dollarSignSize: CGFloat = 0.75
    let edgeWidth: CGFloat = 0.1
    let sparkleSize: CGFloat = 0.15
    let shine1Offset: CGFloat = 0.1
    let shine2Offset: CGFloat = 0.0
    let shineWidth: CGFloat = 0.1
    
    @StateObject private var motionManager = MotionManager()
    let motionStrength: CGFloat = 0.05
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(coinViewModel.userLevel.baseColor)
                .frame(width: coinSize)
            
            Circle()
                .foregroundColor(coinViewModel.userLevel.secondaryColor)
                .frame(width: coinSize - (coinSize * edgeWidth))
            
            Text("$")
                .font(.custom("Nunito-Bold", size: dollarSignSize * coinSize))
                .foregroundColor(coinViewModel.userLevel.baseColor)
            
            Rectangle()
                .frame(width: shineWidth * coinSize, height: coinSize * 1.1)
                .rotationEffect(Angle(degrees: 45))
                .offset(
                    x: -((shine1Offset * coinSize) + (motionManager.x * motionStrength * coinSize)),
                    y: -((shine1Offset * coinSize) + (motionManager.y * motionStrength * coinSize))
                )
                .mask {
                    Circle()
                        .foregroundColor(coinViewModel.userLevel.secondaryColor)
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
    
    init(coinSize: CGFloat, coinViewModel: CoinViewModel) {
        self.coinSize = coinSize
        self.coinViewModel = coinViewModel
    }
}

struct CoinView_Previews: PreviewProvider {
    static let coinViewModel: CoinViewModel = CoinViewModel(userLevel: .ultimateSaver)
    static let coinSize: CGFloat = 300
    
    static var previews: some View {
        CoinView(coinSize: coinSize, coinViewModel: coinViewModel)
    }
}

