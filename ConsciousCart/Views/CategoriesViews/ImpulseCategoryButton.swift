//
//  CategoryButton.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/13/23.
//

import UIKit

class ImpulseCategoryButton: UIControl {
    
    private var categoryLabel: UILabel! = nil
    private var emojiLabel: UILabel! = nil
    private var containerView: UIStackView! = nil
    
    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
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

        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        configureViews()
    }
    
    private func configureViews() {
        backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.borderWidth = 1
        layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        layer.cornerRadius = 10
        
        categoryLabel = UILabel()
        categoryLabel.text = "Category"
        categoryLabel.font = UIFont.ccFont(textStyle: .semibold, fontSize: 15)
        categoryLabel.textColor = .secondaryLabel
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.adjustsFontSizeToFitWidth = true
        categoryLabel.minimumScaleFactor = 0.7
        categoryLabel.textAlignment = .center
        categoryLabel.numberOfLines = 1
        
        emojiLabel = UILabel()
        emojiLabel.text = "☺️"
        emojiLabel.font = .systemFont(ofSize: 28)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.textAlignment = .center
        emojiLabel.numberOfLines = 1
        
        addSubview(categoryLabel)
        addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            categoryLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            
            emojiLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emojiLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20)
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
