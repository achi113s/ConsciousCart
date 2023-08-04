//
//  HackedButton.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/4/23.
//

import UIKit

class HackedButton: UIControl {
    
    public var textLabel: UILabel! = nil
    public var accessoryView: UIImageView! = nil
    public var filterType: ImpulseOption! = nil
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.backgroundColor = self.isHighlighted ? UIColor(white: 0.8, alpha: 1.0) : UIColor.white
            }
        }
    }
    
    init(frame: CGRect, filterType: ImpulseOption) {
        super.init(frame: frame)
        self.filterType = filterType
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    public func setLabelText(_ text: String) {
        textLabel.text = text
    }
    
    private func configureView() {
        backgroundColor = UIColor.white
        
        translatesAutoresizingMaskIntoConstraints = false
        
        textLabel = UILabel()
        textLabel.font = UIFont.ccFont(textStyle: .semibold, fontSize: 17)
        textLabel.textColor = .black
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 1
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textLabel)
        
        accessoryView = UIImageView()
        accessoryView.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold, scale: .default)
        let image = UIImage(systemName: "chevron.right", withConfiguration: config)?.withTintColor(UIColor.init(white: 0.7, alpha: 1.0), renderingMode: .alwaysOriginal)
        accessoryView.image = image
        addSubview(accessoryView)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            accessoryView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            accessoryView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }
}
