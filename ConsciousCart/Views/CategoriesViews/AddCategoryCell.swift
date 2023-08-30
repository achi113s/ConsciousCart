//
//  AddCategoryCell.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/25/23.
//

import UIKit

class AddCategoryCell: UICollectionViewCell {
    static let identifier = "addCategoryCell"
    
    static let scaleWhenCellIsSelected: CGFloat = 0.95
    static let springDamping: CGFloat = 0.3
    static let springVelocity: CGFloat = 10.0
    
    private var plusLabel: UILabel! = nil
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                super.isSelected = true
                
                UIView.animate(
                    withDuration: 1,
                    delay: 0,
                    usingSpringWithDamping: CategoryCell.springDamping,
                    initialSpringVelocity: CategoryCell.springVelocity,
                    options: .allowUserInteraction) {
                    self.transform = CGAffineTransform(scaleX: CategoryCell.scaleWhenCellIsSelected, y: CategoryCell.scaleWhenCellIsSelected)
                }
                
                self.backgroundColor = UIColor(white: 0.90, alpha: 1.0)
            } else {
                super.isSelected = false
                
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0,
                    usingSpringWithDamping: CategoryCell.springDamping,
                    initialSpringVelocity: CategoryCell.springVelocity,
                    options: .allowUserInteraction) {
                    self.transform = CGAffineTransform.identity
                }
                
                self.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.autoresizesSubviews = true
        
        self.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        configureCorners()
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCorners() {
        layer.cornerRadius = 10.0
        layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        layer.borderWidth = 1.0
        // Clip all layers that are bigger than the superlayer.
        // Forces cell highlighting to have the same corner radius.
        layer.masksToBounds = true
    }
    
    private func configureView() {
        plusLabel = UILabel()
        plusLabel.text = "+"
        plusLabel.font = UIFont.ccFont(textStyle: .semibold, fontSize: 45)
        plusLabel.textColor = UIColor(white: 0.5, alpha: 1.0)
        plusLabel.translatesAutoresizingMaskIntoConstraints = false
        plusLabel.adjustsFontSizeToFitWidth = true
        plusLabel.minimumScaleFactor = 0.7
        plusLabel.textAlignment = .center
        
        contentView.addSubview(plusLabel)
        
        NSLayoutConstraint.activate([
            plusLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            plusLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}


