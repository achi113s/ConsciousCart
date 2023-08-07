//
//  SubmitUsername.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/6/23.
//

import UIKit

class SubmitUsernameButton: UIButton {
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
        backgroundColor = .white
        tintColor = .black
        setTitleColor(.black, for: .normal)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel?.font = UIFont.ccFont(textStyle: .uibutton)
    
        configureBorder()
    }
    
    private func configureBorder() {
        layer.borderWidth = 1
        layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        layer.cornerRadius = 10
    }
    
    func shakeAnimation() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.05
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 8, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 8, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
}
