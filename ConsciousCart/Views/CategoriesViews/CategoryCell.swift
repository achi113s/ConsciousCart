//
//  CategoryCell.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/10/23.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    static let identifier = "categoryCell"
    
    static let scaleWhenCellIsSelected: CGFloat = 0.95
    static let springDamping: CGFloat = 0.3
    static let springVelocity: CGFloat = 10.0
    
    private var categoryLabel: UILabel! = nil
    private var emojiLabel: UILabel! = nil
    private var containerView: UIStackView! = nil
    
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
        categoryLabel = UILabel()
        categoryLabel.text = "Category"
        categoryLabel.font = UIFont.ccFont(textStyle: .semibold, fontSize: 15)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.adjustsFontSizeToFitWidth = true
        categoryLabel.minimumScaleFactor = 0.7
        categoryLabel.textAlignment = .center
        
        emojiLabel = UILabel()
        emojiLabel.text = "😁"
        emojiLabel.font = .systemFont(ofSize: 28)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.textAlignment = .center
        
        containerView = UIStackView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.axis = .vertical
        containerView.spacing = 5
        
        containerView.addArrangedSubview(emojiLabel)
        containerView.addArrangedSubview(categoryLabel)
        
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            categoryLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            categoryLabel.heightAnchor.constraint(equalToConstant: 30),
            
            emojiLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            emojiLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    public func setCategoryNameTo(_ categoryName: String) {
        categoryLabel.text = categoryName
    }
    
    public func getCategoryName() -> String {
        return categoryLabel.text ?? ""
    }
    
    public func setEmojiTo(_ emoji: String) {
        emojiLabel.text = emoji
    }
}


