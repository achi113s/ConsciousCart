//
//  ImpulsesFooterViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/2/23.
//

import UIKit

class ImpulsesCategoryNoElementsFooter: UICollectionReusableView {
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        label.text = "Tap the add button below to get started!"
        label.font = UIFont.ccFont(textStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
}
