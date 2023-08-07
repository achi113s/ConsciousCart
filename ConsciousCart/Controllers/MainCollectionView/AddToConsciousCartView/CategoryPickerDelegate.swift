//
//  CategoryPickerDelegate.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/29/23.
//

import UIKit

extension AddToConsciousCartViewController {
    class CategoryPickerDelegate: NSObject, UIPickerViewDelegate {
        func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
            let index = row
            let string =  ImpulseCategory.allCases[index].rawValue
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font : UIFont.ccFont(textStyle: .body)
            ]
            
            let attrString: NSAttributedString = NSAttributedString(string: string, attributes: attributes)
            return attrString
        }
    }
}
