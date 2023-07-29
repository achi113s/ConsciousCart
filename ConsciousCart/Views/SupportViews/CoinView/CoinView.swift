//
//  CoinView.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/28/23.
//

import CoreMotion
import SwiftUI

struct CoinView: View {
    let baseYellow: Color = Color(red: 251/255, green: 197/255, blue: 49/255)
    let secondaryYellow: Color = Color(red: 255/255, green: 221/255, blue: 89/255)
    let tertiaryYellow: Color = Color(red: 255/255, green: 211/255, blue: 42/255)

    @State private var coinSize: CGFloat = 100
    // diameter in points, all dimensions based on this
    // so everything scales correctly if you want to make the coin bigger.
    let dollarSignSize: CGFloat = 0.75
    
    let sparkleSize: CGFloat = 0.15
    let shine1Offset: CGFloat = 0.2
    let shine2Offset: CGFloat = 0.05
    
    @StateObject private var motionManager = MotionManager()
    let motionStrength: CGFloat = 5
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(baseYellow)
                .frame(width: coinSize)
            
            Circle()
                .foregroundColor(secondaryYellow)
                .frame(width: coinSize - 12)
            
            Text("$")
                .font(.custom("Nunito-Bold", size: dollarSignSize * coinSize))
                .foregroundColor(baseYellow)
            
            Rectangle()
                .offset(
                    x: -((shine1Offset * coinSize) + (motionManager.x * motionStrength)),
                    y: (motionManager.y * motionStrength)
                )
                .frame(width: 10, height: coinSize)
                .rotationEffect(Angle(degrees: 45))
                .mask {
                    Circle()
                        .foregroundColor(secondaryYellow)
                        .frame(width: coinSize)
                }
                .foregroundColor(Color.init(white: 0.9, opacity: 0.3))
            
            Rectangle()
                .offset(
                    x: -((shine2Offset * coinSize) + (motionManager.x * motionStrength)),
                    y: (motionManager.y * motionStrength)
                )
                .frame(width: 10, height: coinSize)
                .rotationEffect(Angle(degrees: 45))
                .mask {
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: coinSize)
                }
                .foregroundColor(Color.init(white: 0.9, opacity: 0.3))
            
            Sparkle()
                .frame(width: sparkleSize * coinSize, height: sparkleSize * coinSize * 1.2)
                .offset(
                    x: -((coinSize * 0.25) + (motionManager.x * motionStrength)),
                    y: -((coinSize * 0.2) + (motionManager.y * motionStrength))
                )
                .foregroundColor(Color.init(white: 0.96, opacity: 0.5))
            
            Sparkle()
                .frame(width: sparkleSize * coinSize, height: sparkleSize * coinSize * 1.2)
                .offset(
                    x: ((coinSize * 0.25) - (motionManager.x * motionStrength)),
                    y: ((coinSize * 0.1) - (motionManager.y * motionStrength))
                )
                .foregroundColor(Color.init(white: 0.96, opacity: 0.5))
        }
        .mask {
            Circle()
                .foregroundColor(.white)
                .frame(width: coinSize)
        }
        .onDisappear {
            motionManager.stopMotionUpdates()
        }
    }
    
    init(coinSize: CGFloat) {
        self.coinSize = coinSize
    }
}

struct CoinView_Previews: PreviewProvider {
    static let coinSize: CGFloat = 100
    
    static var previews: some View {
        CoinView(coinSize: coinSize)
    }
}

struct Sparkle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let pointiness: CGFloat = rect.width / 10
            
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addQuadCurve(
                to: CGPoint(x: rect.minX, y: rect.midY),
                control: CGPoint(x: rect.midX - pointiness, y: rect.midY - pointiness)
            )
            
            path.addQuadCurve(
                to: CGPoint(x: rect.midX, y: rect.maxY),
                control: CGPoint(x: rect.midX - pointiness, y: rect.midY + pointiness)
            )
            
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX, y: rect.midY),
                control: CGPoint(x: rect.midX + pointiness, y: rect.midY + pointiness)
            )
            
            path.addQuadCurve(
                to: CGPoint(x: rect.midX, y: rect.minY),
                control: CGPoint(x: rect.midX + pointiness, y: rect.midY - pointiness)
            )
            
            
        }
    }
}
