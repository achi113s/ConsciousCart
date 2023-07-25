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
    
    private var scrollView: UIScrollView!
    private var contentView: UIView!
//    
//    private var impulseStack: UIStackView! = nil
//    private var impulsePropertiesStack: UIStackView! = nil
    
    private var scoreLabel: UILabel!
    private var titleLabel: UILabel!
    private var differentiateWithoutColorIndicator: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "DefaultBackground")
        
        configureScrollView()
        configureSubviews()
        configureLayoutConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setScore()
    }
}

//MARK: - Configure Subviews
extension ProfileViewController {
    private func configureScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = true
    }
    
    private func configureSubviews() {
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "You've saved"
        titleLabel.font = UIFont.ccFont(textStyle: .title)
        titleLabel.textAlignment = .center
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.numberOfLines = 1
        scoreLabel.adjustsFontSizeToFitWidth = true
        scoreLabel.font = UIFont.ccFont(textStyle: .bold, fontSize: 88)
        scoreLabel.textAlignment = .center

        addSubviewsToView()
        
        if UIAccessibility.shouldDifferentiateWithoutColor {
            differentiateScoreWithoutColor()
        } else {
            scoreLabel.textColor = impulsesStateManager?.totalAmountSaved ?? 0.0 >= 0.0 ? .systemGreen : .systemRed
        }
    }
    
    private func addSubviewsToView() {
        view.addSubview(scrollView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(scoreLabel)
        
        scrollView.addSubview(contentView)
    }
    
    private func differentiateScoreWithoutColor() {
        differentiateWithoutColorIndicator = UIImageView()
        
        let arrowConfig = UIImage.SymbolConfiguration(pointSize: CGFloat(scoreLabel.font.pointSize - 20),
                                                      weight: .regular, scale: .default)
        let arrowImage = UIImage(systemName: impulsesStateManager?.totalAmountSaved ?? 0.0 >= 0.0 ? "arrow.up" : "arrow.down",
                                 withConfiguration: arrowConfig)
        
        differentiateWithoutColorIndicator = UIImageView(image: arrowImage)
        differentiateWithoutColorIndicator.tintColor = .black
        differentiateWithoutColorIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(differentiateWithoutColorIndicator)
        
        NSLayoutConstraint.activate([
            differentiateWithoutColorIndicator.centerYAnchor.constraint(equalTo: scoreLabel.centerYAnchor),
            differentiateWithoutColorIndicator.leftAnchor.constraint(equalTo: scoreLabel.rightAnchor, constant: 8)
        ])
    }
    
    private func setScore() {
        let totalSaved = impulsesStateManager?.totalAmountSaved ?? 0.0
        scoreLabel.text = String(totalSaved).asCurrency(locale: Locale.current)
    }
}

//MARK: - Configure Layout Constraints
extension ProfileViewController {
    private func configureLayoutConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 25),
            
            scoreLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            scoreLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            scoreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -16)
        ])
    }
}
