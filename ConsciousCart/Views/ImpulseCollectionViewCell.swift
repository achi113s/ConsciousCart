//
//  ImpulseTableViewCell.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 5/18/23.
//

import UIKit

final class ImpulseCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "impulseCVC"
    
    //    var impulseImg: UIImageView!
    var itemNameLabel: UILabel!
    var itemPriceLabel: UILabel!
    var remainingTimeLabel: UILabel!
    var disclosureAccessory: UIImageView!
    
    var insetView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let labelFont = UIFont.ccFont(textStyle: .body)
        let priceFont = UIFont.ccFont(textStyle: .regular, fontSize: 21)

        let ltr = UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute) == .leftToRight
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold, scale: .large)
        
        insetView = UIView(frame: frame)
        insetView.translatesAutoresizingMaskIntoConstraints = false
        insetView.layer.cornerRadius = 10
        insetView.layer.borderColor = UIColor(white: 0.8, alpha: 1.0).cgColor
        insetView.layer.borderWidth = 1
        
        disclosureAccessory = UIImageView(image:  UIImage(systemName: ltr ? "chevron.right" : "chevron.left", withConfiguration: largeConfig))
        disclosureAccessory.tintColor = .lightGray
        disclosureAccessory.translatesAutoresizingMaskIntoConstraints = false
        insetView.addSubview(disclosureAccessory)
        
        //        impulseImg = UIImageView()
        //        impulseImg.translatesAutoresizingMaskIntoConstraints = false
        //
        itemNameLabel = UILabel()
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        itemNameLabel.font = priceFont
        itemNameLabel.text = "Unknown Item"
        itemNameLabel.numberOfLines = 1
        itemNameLabel.textAlignment = .left
        insetView.addSubview(itemNameLabel)
        
        itemPriceLabel = UILabel()
        itemPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        itemPriceLabel.font = priceFont
        itemPriceLabel.text = "Unknown Price"
        itemPriceLabel.numberOfLines = 0
        itemPriceLabel.textAlignment = .right
        insetView.addSubview(itemPriceLabel)

        remainingTimeLabel = UILabel()
        remainingTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        remainingTimeLabel.text = "Unknown Time"
        remainingTimeLabel.font = labelFont
        remainingTimeLabel.numberOfLines = 0
        remainingTimeLabel.textAlignment = .left
        insetView.addSubview(remainingTimeLabel)

        contentView.addSubview(insetView)
        
        NSLayoutConstraint.activate([
            insetView.topAnchor.constraint(equalTo: contentView.topAnchor),
            insetView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            insetView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            insetView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
            itemNameLabel.leftAnchor.constraint(equalTo: insetView.leftAnchor, constant: 8),
            itemNameLabel.topAnchor.constraint(equalTo: insetView.topAnchor, constant: 8),
            itemNameLabel.widthAnchor.constraint(equalTo: insetView.widthAnchor, multiplier: 0.75),
            
            remainingTimeLabel.leftAnchor.constraint(equalTo: insetView.leftAnchor, constant: 8),
            remainingTimeLabel.bottomAnchor.constraint(equalTo: insetView.bottomAnchor, constant: -8),
            
            disclosureAccessory.rightAnchor.constraint(equalTo: insetView.rightAnchor, constant: -8),
            disclosureAccessory.centerYAnchor.constraint(equalTo: insetView.centerYAnchor),
            
            itemPriceLabel.rightAnchor.constraint(equalTo: disclosureAccessory.leftAnchor, constant: -8),
            itemPriceLabel.centerYAnchor.constraint(equalTo: insetView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
