//
//  ZeroImpulsesViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 6/26/23.
//

import UIKit

class ZeroImpulsesView: UIView {

    private var viewLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        viewLabel.translatesAutoresizingMaskIntoConstraints = false
        viewLabel.text = "Tap the add button to get started!"
        viewLabel.lineBreakMode = .byWordWrapping
        viewLabel.font = UIFont.ccFont(textStyle: .headline)
        viewLabel.textColor = .black
        
        self.addSubview(viewLabel)
        
        NSLayoutConstraint.activate([
            viewLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            viewLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
