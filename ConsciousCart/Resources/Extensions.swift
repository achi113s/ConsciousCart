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
    
    func decode<T: Decodable>(_ file: String, encodingType: UTType) -> T {
        guard let data = try? Data(contentsOf: FileManager.documentsDirectory.appendingPathComponent(file, conformingTo: encodingType)) else {
            fatalError("Failed to load \(file) from Documents.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from Documents.")
        }
        
        return loaded
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
