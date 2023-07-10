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

enum lengthRemainingForImpulse {
    case aLongTime, aMediumTime, aShortTime
}

enum CVSection: Int, CaseIterable {
    case chartSection = 0
    case impulseSection = 1
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

enum UserDefaultsKeys: String {
    case forceDarkModeSetting = "forceDarkMode"
    case accentColor = "accentColor"
}
