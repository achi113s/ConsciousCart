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
                self.sendActions(for: .touchUpInside)
                
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
                    withDuration: 0.1,
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
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        
        configureViews()
        configureAppearance()
    }
    
    private func configureViews() {
        backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        categoryLabel = UILabel()
        categoryLabel.text = "Category"
        categoryLabel.font = UIFont.ccFont(textStyle: .semibold, fontSize: 15)
        categoryLabel.textColor = .secondaryLabel
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.adjustsFontSizeToFitWidth = true
        categoryLabel.minimumScaleFactor = 0.7
        categoryLabel.textAlignment = .center
        
        emojiLabel = UILabel()
        emojiLabel.text = "☺️"
        emojiLabel.font = .systemFont(ofSize: 28)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.textAlignment = .center
        
        containerView = UIStackView(arrangedSubviews: [emojiLabel, categoryLabel])
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.axis = .vertical
        containerView.spacing = 5
        containerView.alignment = .center
        containerView.isUserInteractionEnabled = false
        
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    private func configureAppearance() {
        layer.borderWidth = 1
        layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        layer.cornerRadius = 10
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
