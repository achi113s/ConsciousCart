//
//  ImpulsesCategoryHeader.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 6/30/23.
//

import UIKit

class ImpulsesCategoryHeader: UICollectionReusableView {
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        label.text = "Active Impulses"
        label.font = UIFont.ccFont(textStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
}
