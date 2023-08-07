//
//  CategoryPickerSupport.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/29/23.
//

import UIKit

extension AddToConsciousCartViewController {
    class CategoryPickerDataSource: NSObject, UIPickerViewDataSource {
        var impulsesStateManager: ImpulsesStateManager? = nil
        
        init(impulsesStateManager: ImpulsesStateManager? = nil) {
            self.impulsesStateManager = impulsesStateManager
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return ImpulseCategory.allCases.count
        }
    }
}
