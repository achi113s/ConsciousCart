//
//  ChangeImageButton.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 5/14/23.
//

import UIKit

final class ChangeImageContainerView: UIView {
    var containerView: UIView!
    var imageView: UIImageView!
    private var changeImageButton: UIButton!
    
    private let borderWidth: CGFloat = 1
    private let borderColor: CGColor = UIColor.black.cgColor
    private let cornerRadius: CGFloat = 25
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
//        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
//        configureConstraints()
    }
    
    func configureView() {
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.borderWidth = borderWidth
        containerView.layer.borderColor = borderColor
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.masksToBounds = true

        changeImageButton = UIButton()
        changeImageButton.translatesAutoresizingMaskIntoConstraints = false
        changeImageButton.setTitle("Change Image", for: .normal)
        changeImageButton.tintColor = .white
        changeImageButton.setTitleColor(.gray, for: .highlighted)
        changeImageButton.backgroundColor = UIColor(white: 0.05, alpha: 0.8)
        changeImageButton.layer.cornerRadius = cornerRadius
        changeImageButton.layer.masksToBounds = true
        
        containerView.addSubview(imageView)
        containerView.addSubview(changeImageButton)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            changeImageButton.heightAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 0.3),
            changeImageButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            changeImageButton.widthAnchor.constraint(equalTo: imageView.widthAnchor),
            
            imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: containerView.widthAnchor)
        ])
    }
}
