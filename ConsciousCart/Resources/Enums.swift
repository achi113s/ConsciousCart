//
//  Enums.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/7/23.
//

import Foundation

enum ChartTimeDomain: String, CaseIterable, Identifiable {
    case threeMonths = "3M"
    case sixMonths = "6M"
    case oneYear = "1Y"
    case allTime = "All"
    var id: Self { self }
}

enum ImpulseCategory: CaseIterable {
    case clothing
    case electronics
    case entertainment
    case restaurants
    case shoes
    
    var categoryEmoji: String {
        switch self {
        case .clothing:
            return "👕"
        case .electronics:
            return "💻"
        case .entertainment:
            return "🍿"
        case .restaurants:
            return "🍽️"
        case .shoes:
            return "👟"
        }
    }
    
    var categoryName: String {
        switch self {
        case .clothing:
            return "Clothing"
        case .electronics:
            return "Electronics"
        case .entertainment:
            return "Entertainment"
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

enum UserLevel: Int {
    case beginner = 0
    case saver = 1
    case superSaver = 2
    case ultimateSaver = 3
}
