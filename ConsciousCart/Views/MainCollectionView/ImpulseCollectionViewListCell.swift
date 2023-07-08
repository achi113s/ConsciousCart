//
//  ImpulseCollectionViewListCell.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/2/23.
//

import UIKit

class ImpulseCollectionViewListCell: UICollectionViewListCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureAppearance() {
        configureCorners()
//        configureShadows()
    }
    
    // Need to figure out how to make this work with the rounded corners.
    // Problem is masksToBounds needs to be true to have nice corners,
    // but then the shadows are clipped because they are outside the bounds.
    private func configureShadows() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.red.cgColor
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.1
    }
    
    private func configureCorners() {
        layer.cornerRadius = 10.0
        layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        layer.borderWidth = 1.0
        // Clip all layers that are bigger than the superlayer.
        // Forces cell highlighting to have the same corner radius.
        layer.masksToBounds = true
    }
}
