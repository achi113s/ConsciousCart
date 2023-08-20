//
//  UIViewControllerExtensions.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/19/23.
//

import UIKit

//MARK: - Extension to Hide Keyboard on Tap
extension UIViewController {
    func initializeHideKeyboardOnTap(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboardOnTap))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboardOnTap(){
        view.endEditing(true)
    }
}
