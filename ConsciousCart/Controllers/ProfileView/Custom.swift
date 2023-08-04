//
//  Custom.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/4/23.
//

import UIKit

class Custom: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureButton()
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.backgroundColor = self.isHighlighted ? UIColor(white: 0.8, alpha: 1.0) : UIColor.white
            }
        }
    }
    
    func configureButton() {
        backgroundColor = UIColor.white
        tintColor = .black
        
        self.setTitleColor(.black, for: .normal)
        contentHorizontalAlignment = .leading
        
        translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel?.font = UIFont.ccFont(textStyle: .semibold, fontSize: 17)
        
        isHighlighted = false
        
        layer.borderWidth = 1
        layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        layer.cornerRadius = 10
    }
}
