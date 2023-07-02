//
//  Utils.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 5/18/23.
//

import SwiftUI
import UIKit

struct Item: Identifiable {
    var id = UUID()
    let date: Date
    let value: Double
}

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

enum MainCollectionViewCellReuseIdentifiers: String {
    case defaultCellReuseIdentifier = "cell"
    case savingsChartCellReuseIdentifier = "savingsChartCell"
    case noImpulsesCellReuseIdentifier = "noImpulsesCell"
    case impulseCellReuseIdentifier = "impulseCell"
    case impulsesCategoryHeaderIdentifier = "impulsesCategoryHeaderId"
    case headerIdentifier = "headerId"
}

enum UserDefaultsKeys: String {
    case forceDarkModeSetting = "forceDarkMode"
}

class Utils {
    static func printFonts() {
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
            
        }
    }
    
    static func formatNumberAsCurrency(_ price: NSNumber) -> String {
        let formatter = NumberFormatter()

        formatter.numberStyle = .currency
        formatter.locale = NSLocale.current
        
        let priceString: String? = formatter.string(from: price)
        
        return priceString ?? "$0.00"
    }
    
    static func calculateTimeRemainingUntil(_ futureDate: Date) -> DateComponents {
        let now = Date()
        
        let diff = Calendar.current.dateComponents([.day, .hour, .minute], from: now, to: futureDate)
        
        return diff
    }
    
    static func remainingTimeMessageForDate(_ futureDate: Date) -> (String, lengthRemainingForImpulse) {
        let remainingTime = calculateTimeRemainingUntil(futureDate)
        
        if let day = remainingTime.day {
            if day > 2 {
                return ("⏳ \(day) Days Remaining", .aLongTime)
            } else if day > 1 {
                return ("⏳ \(day) Days Remaining", .aMediumTime)
            } else if day == 1 {
                return ("⏳ \(day) Day Remaining", .aShortTime)
            } else {
                return ("⏳ \(day) Days Remaining", .aShortTime)
            }
        } else if let hour = remainingTime.hour {
            return hour == 1 ? ("⏳ \(hour) Hour Remaining", .aShortTime) : ("⏳ \(hour) Hours Remaining", .aShortTime)
        } else if let minute = remainingTime.minute {
            return minute == 1 ? ("⏳ \(minute) Minute Remaining", .aShortTime) : ("⏳ \(minute) Minutes Remaining", .aShortTime)
        }
        
        return ("Time's up!", .aLongTime)
    }
    
    static let chartTestItems: [Item] = [
        Item(date: Date(timeIntervalSince1970: 1630574339), value: -800),
        Item(date: Date(timeIntervalSince1970: 1671274339), value: -120),
        Item(date: Date(timeIntervalSince1970: 1672274339), value: -20),
        Item(date: Date(timeIntervalSince1970: 1673274339), value: -55),
        Item(date: Date(timeIntervalSince1970: 1674274339), value: -170),
        Item(date: Date(timeIntervalSince1970: 1675274339), value: -20),
        Item(date: Date(timeIntervalSince1970: 1676274339), value: 10),
        Item(date: Date(timeIntervalSince1970: 1677274339), value: 5),
        Item(date: Date(timeIntervalSince1970: 1678274339), value: 1),
        Item(date: Date(timeIntervalSince1970: 1679274339), value: 500),
        Item(date: Date(timeIntervalSince1970: 1680274339), value: 800),
        Item(date: Date(timeIntervalSince1970: 1681274339), value: 900),
        Item(date: Date(timeIntervalSince1970: 1682274339), value: -430),
        Item(date: Date(timeIntervalSince1970: 1683274339), value: -700),
        Item(date: Date(timeIntervalSince1970: 1684544894), value: -300.23)
    ]
}

extension UICollectionViewCell {
    /// Refreshes the cell's contentView by removing all of its subviews.
    func refreshContentView() {
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
    }
}
