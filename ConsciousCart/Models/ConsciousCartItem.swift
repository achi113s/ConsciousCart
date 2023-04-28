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
    let name: String = ""
    let price: Double = 0
}
