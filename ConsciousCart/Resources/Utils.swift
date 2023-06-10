//
//  Utils.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 5/18/23.
//

import UIKit

class Utils {
    static func printFonts() {
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
            
        }
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
    
    enum lengthRemainingForImpulse {
        case aLongTime, aMediumTime, aShortTime
    }
    
}
