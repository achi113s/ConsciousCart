//
//  ProfileViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 4/27/23.
//

import SwiftUI
import UIKit

class ProfileViewController: UIViewController {
    var impulsesStateManager: ImpulsesStateManager?
    
    private var scoreLabel: UILabel!
    private var titleLabel: UILabel!
    private var differentiateWithoutColorIndicator: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureSubviews()
        configureSubviewsText()
        configureLayoutConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSubviewsText()
    }
    
    private func configureSubviews() {
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Your ConsciousCart score is"
        titleLabel.font = UIFont.ccFont(textStyle: .title)
        titleLabel.textAlignment = .center
        
        scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.numberOfLines = 1
        scoreLabel.adjustsFontSizeToFitWidth = true
        scoreLabel.font = UIFont.ccFont(textStyle: .title)
        scoreLabel.textColor = .systemGreen
        
        differentiateWithoutColorIndicator.tintColor = .black
        differentiateWithoutColorIndicator.translatesAutoresizingMaskIntoConstraints = false
        differentiateWithoutColorIndicator.isHidden = UIAccessibility.shouldDifferentiateWithoutColor
        
        view.addSubview(titleLabel)
        view.addSubview(scoreLabel)
        view.addSubview(differentiateWithoutColorIndicator)
    }
    
    private func configureSubviewsText() {
        let totalAmountSaved = impulsesStateManager?.totalAmountSaved ?? 0.0
        
        scoreLabel.text = Utils.formatNumberAsCurrency(NSNumber(value: totalAmountSaved))
        
        let arrowConfig = UIImage.SymbolConfiguration(pointSize: scoreLabel.font.pointSize,
                                                      weight: .regular, scale: .default)
        let arrowImage = UIImage(systemName: totalAmountSaved >= 0.0 ? "arrow.up" : "arrow.down",
                                 withConfiguration: arrowConfig)
        differentiateWithoutColorIndicator = UIImageView(image: arrowImage)
    }
    
    private func configureLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scoreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -16),
            
            differentiateWithoutColorIndicator.centerYAnchor.constraint(equalTo: scoreLabel.centerYAnchor),
            differentiateWithoutColorIndicator.leftAnchor.constraint(equalTo: scoreLabel.rightAnchor, constant: 8)
        ])
    }
    
    
}
