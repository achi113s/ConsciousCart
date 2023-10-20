//
//  StringExtensions.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/31/23.
//

import Foundation

extension String {
    func asCurrency(locale: Locale) -> String? {
        Formatter.currency.locale = locale
        if self.isEmpty {
            return Formatter.currency.string(from: NSNumber(value: 0))
        } else {
            return Formatter.currency.string(from: NSNumber(value: Double(self) ?? 0))
        }
    }
    
    // This function by me.
    func asDoubleFromCurrency(locale: Locale) -> Double {
        Formatter.currency.locale = locale
        let number = Formatter.currency.number(from: self)
        
        if let number {
            return number.doubleValue
        } else {
            return 0.0
        }
    }
    
    // By gavanon on StackOverflow
    // https://stackoverflow.com/a/46859176/21574991
    func isAlphanumeric() -> Bool {
        return self.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil && self != ""
    }
    
    func isAlphanumeric(ignoreDiacritics: Bool = false) -> Bool {
        if ignoreDiacritics {
            return self.range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil && self != ""
        }
        else {
            return self.isAlphanumeric()
        }
    }
    
    func containsEmoji() -> Bool {
        contains { $0.isEmoji }
    }

    func containsOnlyEmojis() -> Bool {
        return count > 0 && !contains { !$0.isEmoji }
    }
    
    func stringInputIsValid() -> Bool {
        if self.trimmingCharacters(in: .whitespacesAndNewlines) == "" { return false }
        return true
    }
}

extension Character {
    // An emoji can either be a 2 byte unicode character or a normal UTF8 character with an emoji modifier
    // appended as is the case with 3️⃣. 0x203C is the first instance of UTF16 emoji that requires no modifier.
    // `isEmoji` will evaluate to true for any character that can be turned into an emoji by adding a modifier
    // such as the digit "3". To avoid this we confirm that any character below 0x203C has an emoji modifier attached
    var isEmoji: Bool {
        guard let scalar = unicodeScalars.first else { return false }
        return scalar.properties.isEmoji && (scalar.value >= 0x203C || unicodeScalars.count > 1)
    }
}
