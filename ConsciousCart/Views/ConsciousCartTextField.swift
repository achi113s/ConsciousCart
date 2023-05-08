//
//  ConsciousCartTextField.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 5/3/23.
//

import UIKit

final class ConsciousCartTextField: UITextField {
    var textPadding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureTextField()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    func configureTextField() {
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .secondarySystemBackground
        
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
    }
}
