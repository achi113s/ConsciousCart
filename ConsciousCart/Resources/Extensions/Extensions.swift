//
//  Extensions.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/7/23.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers

extension FileManager {
    static var documentsDirectory: URL {
        let paths = self.default.urls(for: .documentDirectory, in: .userDomainMask)
        //        print(paths[0])
        return paths[0]
    }
    
    func decode<T: Decodable>(_ file: String, encodingType: UTType) -> T? {
        guard let data = try? Data(contentsOf: FileManager.documentsDirectory.appendingPathComponent(file, conformingTo: encodingType)) else {
            return nil
            //            fatalError("Failed to load \(file) from Documents.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            return nil
            //            fatalError("Failed to decode \(file) from Documents.")
        }
        
        return loaded
    }
    
    func encode<T: Encodable>(_ data: T, fileName: String, encodingType: UTType) {
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(data) else {
            fatalError("Failed to encode data.")
        }
        
        try? encoded.write(to: FileManager.documentsDirectory.appendingPathComponent(fileName, conformingTo: encodingType), options: [.atomic])
    }
}

// Formatter and String extensions originally by NSExceptional on StackOverflow.
// https://stackoverflow.com/a/60859491/21574991
extension Formatter {
    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
}

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
    
    func stringInputIsValid() -> Bool {
        if self.trimmingCharacters(in: .whitespacesAndNewlines) == "" { return false }
        return true
    }
}

extension UIColor {
    /**
     Create a lighter color
     */
    func lighter(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjustBrightness(by: abs(percentage))
    }
    
    /**
     Create a darker color
     */
    func darker(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjustBrightness(by: -abs(percentage))
    }
    
    /**
     Try to increase brightness or decrease saturation
     */
    func adjustBrightness(by percentage: CGFloat = 30.0) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
            if b < 1.0 {
                let newB: CGFloat = max(min(b + (percentage/100.0)*b, 1.0), 0.0)
                return UIColor(hue: h, saturation: s, brightness: newB, alpha: a)
            } else {
                let newS: CGFloat = min(max(s - (percentage/100.0)*s, 0.0), 1.0)
                return UIColor(hue: h, saturation: newS, brightness: b, alpha: a)
            }
        }
        return self
    }
}

extension UILabel {
    func countAnimation(upto: Double) {
        let from: Double = text?.asDoubleFromCurrency(locale: Locale.current) ?? 0.0
        
        let steps: Int = 50
        let duration = 0.5
        let delay = duration / Double(steps)
        
        let diff = upto - from
        let step = diff / Double(steps)
        
        for i in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay * Double(i)) {
                let newValue = from + (step * Double(i))
                let newValueAsString = "\(newValue)".asCurrency(locale: Locale.current)
                self.text = newValueAsString
            }
        }
    }
}

/// Color extension to UserDefaults by Andrew on StackOverflow.
/// https://stackoverflow.com/a/30576832/21574991
extension UserDefaults {
    func color(forKey key: String) -> UIColor? {
        guard let colorData = data(forKey: key) else { return nil }
        
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
        } catch {
            print("Color error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func set(_ value: UIColor?, forKey key: String) {
        guard let color = value else { return }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            set(data, forKey: key)
        } catch {
            print("Color error, color key not saved: \(error.localizedDescription)")
        }
    }
}
