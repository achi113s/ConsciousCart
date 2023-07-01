//
//  ImpulseTableViewCell.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 5/18/23.
//

import UIKit

final class ImpulseCollectionViewCell: UICollectionViewCell {
    var itemNameLabel: UILabel!
    var itemPriceLabel: UILabel!
    var remainingTimeLabel: UILabel!
    var disclosureAccessory: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let labelFont = UIFont.ccFont(textStyle: .body)
        let priceFont = UIFont.ccFont(textStyle: .regular, fontSize: 21)

        let ltr = UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute) == .leftToRight
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold, scale: .large)
        
        disclosureAccessory = UIImageView(image:  UIImage(systemName: ltr ? "chevron.right" : "chevron.left", withConfiguration: largeConfig))
        disclosureAccessory.tintColor = .lightGray
        disclosureAccessory.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(disclosureAccessory)
        
        itemNameLabel = UILabel()
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        itemNameLabel.font = priceFont
        itemNameLabel.text = "Unknown Item"
        itemNameLabel.numberOfLines = 1
        itemNameLabel.textAlignment = .left
        contentView.addSubview(itemNameLabel)
        
        itemPriceLabel = UILabel()
        itemPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        itemPriceLabel.font = priceFont
        itemPriceLabel.text = "Unknown Price"
        itemPriceLabel.numberOfLines = 0
        itemPriceLabel.textAlignment = .right
        contentView.addSubview(itemPriceLabel)

        remainingTimeLabel = UILabel()
        remainingTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        remainingTimeLabel.text = "Unknown Time"
        remainingTimeLabel.font = labelFont
        remainingTimeLabel.numberOfLines = 0
        remainingTimeLabel.textAlignment = .left
        contentView.addSubview(remainingTimeLabel)
        
        setCellLayoutConstraints()
        
        setCellShadow()
        
        setCellCorners()
    }
    
    func setCellLayoutConstraints() {
        NSLayoutConstraint.activate([
            itemNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            itemNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            itemNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75),
            
            remainingTimeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            remainingTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            disclosureAccessory.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            disclosureAccessory.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            itemPriceLabel.rightAnchor.constraint(equalTo: disclosureAccessory.leftAnchor, constant: -8),
            itemPriceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func setCellCorners() {
        layer.cornerRadius = 10.0
        layer.borderColor = UIColor(white: 0.8, alpha: 1.0).cgColor
        layer.borderWidth = 1.0
        
        contentView.layer.cornerRadius = 10.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
    }
    
    func setCellShadow() {
        contentView.backgroundColor = UIColor.systemBackground
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.1
        layer.masksToBounds = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
