//
//  SparkleShape.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/28/23.
//

import SwiftUI

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
