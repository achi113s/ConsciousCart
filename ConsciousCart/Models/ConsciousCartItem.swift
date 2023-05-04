//
//  ConsciousCartItem.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 4/28/23.
//

import SwiftUI
import UIKit

struct ConsciousCartItem: Identifiable {
    var id: UUID = UUID()
    
    let dateCreated: Date = Date.now
    let waitTime: TimeInterval
    var remindDate: Date {
        dateCreated.addingTimeInterval(waitTime)
    }
    
    var name: String
    var price: Double
    var reasonNeeded: String
}
