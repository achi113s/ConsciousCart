//
//  ActiveImpulseCollectionViewCell.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/4/23.
//

import UIKit

class ActiveImpulseCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10.0
        layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        layer.borderWidth = 1.0
        // Clip all layers that are bigger than the superlayer.
        // Forces cell highlighting to have the same corner radius.
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
