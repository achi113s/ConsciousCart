//
//  ImpulseCollectionViewCell.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 6/17/23.
//

import UIKit

class ImpulseCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ImpulseCollectionCell"

    var itemNameLabel: UILabel!
//    var itemPriceLabel: UILabel!
//    var remainingTimeLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        itemNameLabel = UILabel()
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
//        itemNameLabel.font = priceFont
        itemNameLabel.text = "Pokemon Cards"
        itemNameLabel.numberOfLines = 0
        itemNameLabel.textAlignment = .left
        addSubview(itemNameLabel)
//        insetView.addSubview(itemNameLabel)
        
        
        NSLayoutConstraint.activate([
            itemNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            itemNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            itemNameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5)
//
//            remainingTimeLabel.leftAnchor.constraint(equalTo: insetView.leftAnchor, constant: 8),
//            remainingTimeLabel.bottomAnchor.constraint(equalTo: insetView.bottomAnchor, constant: -8),
//
//            itemPriceLabel.rightAnchor.constraint(equalTo: insetView.rightAnchor, constant: -30),
//            itemPriceLabel.centerYAnchor.constraint(equalTo: insetView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


//class ImpulseTableViewCell: UITableViewCell {
//
//    //    var impulseImg: UIImageView!
//    var itemNameLabel: UILabel!
//    var itemPriceLabel: UILabel!
//    var remainingTimeLabel: UILabel!
//
//    var insetView: UIView!
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
////        accessoryType = .disclosureIndicator
//        let accessory = UIImageView(image: UIImage(systemName: "chevron.right"))
//        accessory.tintColor = .lightGray
//        accessoryView = accessory
//
//        let labelFont = UIFont(name: "Nunito-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17)
//        let priceFont = UIFont(name: "Nunito-Regular", size: 21) ?? UIFont.systemFont(ofSize: 21)
//
//        insetView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        insetView.translatesAutoresizingMaskIntoConstraints = false
//        insetView.layer.cornerRadius = 10
//        insetView.layer.borderColor = UIColor(white: 0.8, alpha: 1.0).cgColor
//        insetView.layer.borderWidth = 1
//
//        //        impulseImg = UIImageView()
//        //        impulseImg.translatesAutoresizingMaskIntoConstraints = false
//        //
//        itemNameLabel = UILabel()
//        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
//        itemNameLabel.font = priceFont
//        itemNameLabel.text = "Pokemon Cards"
//        itemNameLabel.numberOfLines = 0
//        itemNameLabel.textAlignment = .left
//        insetView.addSubview(itemNameLabel)
//
//        itemPriceLabel = UILabel()
//        itemPriceLabel.translatesAutoresizingMaskIntoConstraints = false
//        itemPriceLabel.font = priceFont
//        itemPriceLabel.text = "$9.99"
//        itemPriceLabel.numberOfLines = 0
//        itemPriceLabel.textAlignment = .right
//        insetView.addSubview(itemPriceLabel)
//
//        remainingTimeLabel = UILabel()
//        remainingTimeLabel.translatesAutoresizingMaskIntoConstraints = false
//        let remainingTime = Utils.remainingTimeMessageForDate(Date(timeIntervalSince1970: 1684905231))
//        remainingTimeLabel.text = remainingTime.0
//        remainingTimeLabel.textColor = remainingTime.1 == .aLongTime ? .black : .red
//        remainingTimeLabel.font = labelFont
//        remainingTimeLabel.numberOfLines = 0
//        remainingTimeLabel.textAlignment = .left
//        insetView.addSubview(remainingTimeLabel)
//
//
//        addSubview(insetView)
//
//        NSLayoutConstraint.activate([
//            insetView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
//            insetView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
//            insetView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
//            insetView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
//
//            itemNameLabel.leftAnchor.constraint(equalTo: insetView.leftAnchor, constant: 8),
//            itemNameLabel.topAnchor.constraint(equalTo: insetView.topAnchor, constant: 8),
//            itemNameLabel.widthAnchor.constraint(equalTo: insetView.widthAnchor, multiplier: 0.5),
//
//            remainingTimeLabel.leftAnchor.constraint(equalTo: insetView.leftAnchor, constant: 8),
//            remainingTimeLabel.bottomAnchor.constraint(equalTo: insetView.bottomAnchor, constant: -8),
//
//            itemPriceLabel.rightAnchor.constraint(equalTo: insetView.rightAnchor, constant: -30),
//            itemPriceLabel.centerYAnchor.constraint(equalTo: insetView.centerYAnchor),
//        ])
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        let bottomSpace: CGFloat = 400.0 // Let's assume the space you want is 10
//        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: bottomSpace, right: 0))
//    }
//
//    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
//        UIView.animate(withDuration: 0.4) {
//            self.insetView.backgroundColor = highlighted ? .lightGray : .white
//        }
//    }
//
//}
