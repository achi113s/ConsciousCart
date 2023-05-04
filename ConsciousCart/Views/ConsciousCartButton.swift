//
//  CCNormalButton.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 4/23/23.
//

import UIKit

final class ConsciousCartButton: UIButton {
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
                self.backgroundColor = self.isHighlighted ? UIColor(named: "GloomyPurple") : UIColor(named: "LightPurple")
                self.transform = self.isHighlighted ? CGAffineTransform(translationX: 0, y: 3) : CGAffineTransform.identity
                self.layer.shadowOffset = self.isHighlighted ? CGSize(width: 0.0, height: 0) : CGSize(width: 0.0, height: 3.0)
            }
        }
    }
    
    func configureButton() {
        backgroundColor = UIColor(named: "LightPurple")
        tintColor = .black
        self.setTitleColor(.black, for: .normal)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        isHighlighted = false
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 25
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 0
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
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
