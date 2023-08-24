//
//  Enums.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/7/23.
//

import UIKit
import SwiftUI

enum ChartTimeDomain: String, CaseIterable, Identifiable {
    case threeMonths = "3M"
    case sixMonths = "6M"
    case oneYear = "1Y"
    case allTime = "All"
    var id: Self { self }
}

enum ImpulseCategory: CaseIterable {
    case books
    case clothing
    case electronics
    case entertainment
    case home
    case restaurants
    case shoes
    
    var categoryEmoji: String {
        switch self {
        case .books:
            return "📚"
        case .clothing:
            return "👕"
        case .electronics:
            return "💻"
        case .entertainment:
            return "🍿"
        case .home:
            return "🏡"
        case .restaurants:
            return "🍽️"
        case .shoes:
            return "👟"
        }
    }
    
    var categoryName: String {
        switch self {
        case .books:
            return "Books"
        case .clothing:
            return "Clothing"
        case .electronics:
            return "Electronics"
        case .entertainment:
            return "Entertainment"
        case .home:
            return "Home"
        case .restaurants:
            return "Restaurants"
        case .shoes:
            return "Shoes"
        }
    }
}

enum ImpulseEndedOptions {
    case waited
    case waitedAndWillBuy
    case failed
}

enum ImpulseOption {
    case active
    case pending
    case completed
}

enum lengthRemainingForImpulse {
    case aLongTime, aMediumTime, aShortTime
}

enum CVSection: Int, CaseIterable {
    case chartSection = 0
    case impulseSection = 1
}

enum NotificationCategory: String {
    case impulseExpired = "impulseExpired"
}

enum MainCollectionViewReuseIdentifiers: String {
    case defaultCellReuseIdentifier = "cell"
    case savingsChartCellReuseIdentifier = "savingsChartCell"
    case noImpulsesCellReuseIdentifier = "noImpulsesCell"
    case impulseCellReuseIdentifier = "impulseCell"
    case impulsesCategoryHeaderIdentifier = "impulsesCategoryHeaderId"
    case headerIdentifier = "headerId"
    case impulsesCategoryFooterIdentifier = "impulsesCategoryFooterId"
    case footerIdentifier = "footerId"
}

enum TabBarKeys: Int {
    case mainTab = 0
    case profileTab = 1
    case settingsTab = 2
}

enum UserDefaultsKeys: String {
    case forceDarkModeSetting = "forceDarkMode"
    case accentColor = "accentColor"
    case allowHaptics = "allowHaptics"
}

enum UserLevel: Int, CaseIterable {
    case beginner = 0
    case saver = 1
    case superSaver = 2
    case ultimateSaver = 3
    
    var baseColor: Color {
        switch self {
        case .beginner:
            return Color("Soil")  // Soil
        case .saver:
            return Color("LondonSquare")  // London Square
        case .superSaver:
            return Color("NYCTaxi")  // NYC Taxi
        case .ultimateSaver:
            return Color("HintOfIce")  // Hint of Ice
        }
    }
    
    var secondaryColor: Color {
        switch self {
        case .beginner:
            return Color("SpoiledChocolate")  // Spoiled Chocolate
        case .saver:
            return Color("HintOfElusiveBlue") // Hint of Elusive Blue
        case .superSaver:
            return Color("Yriel")  // Yriel Yellow
        case .ultimateSaver:
            return Color("Spray")  // Spray
        }
    }
}
