//
//  ConsciousCartTextField.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 5/3/23.
//

import UIKit

final class ConsciousCartTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureTextField()
    }
    
    func configureTextField() {
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .lightGray
        
        self.layer.cornerRadius = 15
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
    }
}
