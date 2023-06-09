//
//  Extensions.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/7/23.
//

import SwiftUI
import UIKit

//MARK: - Extension to Hide Keyboard on Tap
extension UIViewController {
    func initializeHideKeyboardOnTap(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboardOnTap))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboardOnTap(){
        view.endEditing(true)
    }
}

/// Formatter and String extensions originally by NSExceptional on StackOverflow.
/// https://stackoverflow.com/a/60859491/21574991
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
    
    /// This function by me.
    func asDoubleFromCurrency(locale: Locale) -> Double {
        Formatter.currency.locale = locale
        let number = Formatter.currency.number(from: self)
        
        if let number {
            return number.doubleValue
        } else {
            return 0.0
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
