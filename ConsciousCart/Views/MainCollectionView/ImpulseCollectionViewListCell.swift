//
//  ImpulseCollectionViewListCell.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/2/23.
//

import UIKit

final class ImpulseCollectionViewListCell: UICollectionViewListCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCorners()
        configureShadows()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureShadows() {
//        contentView.backgroundColor = UIColor.systemBackground
//        layer.backgroundColor = UIColor.clear.cgColor
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowRadius = 5
//        layer.shadowOffset = CGSize(width: 0, height: 5)
//        layer.shadowOpacity = 0.1
        
    }
    
    private func configureCorners() {
        layer.cornerRadius = 10.0
        layer.borderColor = UIColor(white: 0.8, alpha: 1.0).cgColor
        layer.borderWidth = 1.0
        layer.masksToBounds = true

        contentView.layer.cornerRadius = 10.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
    }
}
