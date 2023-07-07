//
//  ImpulseCollectionViewListCell.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/2/23.
//

import UIKit

final class ImpulseCollectionViewListCell: UICollectionViewListCell {
//    var itemNameLabel: UILabel!
//    var itemPriceLabel: UILabel!
//    var remainingTimeLabel: UILabel!
//    var disclosureAccessory: UIImageView!
//
    var containerView: UIView!
    var customSeparator: UIView!
    let bottomPadding: CGFloat = 5.0
//    
//    private let labelFont = UIFont.ccFont(textStyle: .body)
//    private let priceFont = UIFont.ccFont(textStyle: .regular, fontSize: 21)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSubviews()
        configureLayoutConstraints()
        
        configureCorners()
        //        configureShadows()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubviews() {
//        customContentView = UIView()
//        customContentView.translatesAutoresizingMaskIntoConstraints = false
//        customContentView.backgroundColor = .systemBackground
//        contentView.addSubview(customContentView)
        contentView.removeFromSuperview()
        
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .clear
        containerView.addSubview(contentView)
        addSubview(containerView)
        
        //        let ltr = UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute) == .leftToRight
        //        let largeConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold, scale: .large)
        //
        //        disclosureAccessory = UIImageView(image:  UIImage(systemName: ltr ? "chevron.right" : "chevron.left", withConfiguration: largeConfig))
        //        disclosureAccessory.tintColor = .lightGray
        //        disclosureAccessory.translatesAutoresizingMaskIntoConstraints = false
        //
        //        itemNameLabel = UILabel()
        //        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        //        itemNameLabel.font = priceFont
        //        itemNameLabel.text = "Unknown Item"
        //        itemNameLabel.numberOfLines = 1
        //        itemNameLabel.textAlignment = .left
        //
        //        itemPriceLabel = UILabel()
        //        itemPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        //        itemPriceLabel.font = priceFont
        //        itemPriceLabel.text = "Unknown Price"
        //        itemPriceLabel.numberOfLines = 0
        //        itemPriceLabel.textAlignment = .right
        //
        //        remainingTimeLabel = UILabel()
        //        remainingTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        //        remainingTimeLabel.text = "Unknown Time"
        //        remainingTimeLabel.font = labelFont
        //        remainingTimeLabel.numberOfLines = 0
        //        remainingTimeLabel.textAlignment = .left
        //
        //        contentView.addSubview(disclosureAccessory)
        //        contentView.addSubview(itemNameLabel)
        //        contentView.addSubview(itemPriceLabel)
        //        contentView.addSubview(remainingTimeLabel)
        customSeparator = UIView()
        customSeparator.translatesAutoresizingMaskIntoConstraints = false
        customSeparator.backgroundColor = .red
        containerView.addSubview(customSeparator)
    }
    
    private func configureLayoutConstraints() {
        //        NSLayoutConstraint.activate([
        //            itemNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
        //            itemNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
        //            itemNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75),
        //
        //            remainingTimeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
        //            remainingTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        //
        //            disclosureAccessory.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
        //            disclosureAccessory.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        //
        //            itemPriceLabel.rightAnchor.constraint(equalTo: disclosureAccessory.leftAnchor, constant: -8),
        //            itemPriceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        //        ])
        
//        NSLayoutConstraint.activate([
//            customContentView.heightAnchor.constraint(equalToConstant: 150),
//            customContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            customContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            customContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentPadding),
//            customContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentPadding)
//        ])
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            customSeparator.heightAnchor.constraint(equalToConstant: bottomPadding),
            customSeparator.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            customSeparator.topAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
//    private func configureCorners() {
////        layer.cornerRadius = 10.0
////        layer.borderColor = UIColor(white: 0.8, alpha: 1.0).cgColor
////        layer.borderWidth = 1.0
////        layer.masksToBounds = true
//        layer.backgroundColor = UIColor.clear.cgColor
//        customContentView.layer.cornerRadius = 10.0
//        customContentView.layer.borderWidth = 1.0
//        customContentView.layer.borderColor = UIColor(white: 0.8, alpha: 1.0).cgColor
//        customContentView.layer.masksToBounds = true
//    }
//
    private func configureShadows() {
        contentView.backgroundColor = UIColor.systemBackground
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.1
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
//
//    private func configureShadows() {
//        contentView.backgroundColor = UIColor.systemBackground
//        layer.backgroundColor = UIColor.clear.cgColor
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowRadius = 5
//        layer.shadowOffset = CGSize(width: 0, height: 5)
//        layer.shadowOpacity = 0.1
//    }
}
