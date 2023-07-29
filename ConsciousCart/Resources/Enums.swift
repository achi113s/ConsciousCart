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

enum ImpulseCategory: String, CaseIterable {
    case clothing = "clothing"
    case electronics = "electronics"
    case general = "general"
    case restaurants = "restaurants"
    case videoGames = "videoGames"
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
}

enum UserLevel {
    case beginner
    case saver
    case superSaver
    case ultimateSaver
}
