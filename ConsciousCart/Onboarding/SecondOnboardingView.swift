//
//  WelcomeViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/5/23.
//

import UIKit

class SecondOnboardingView: UIViewController {
    private var titleLabel: UILabel = UILabel()
    private var subtitleLabel: UILabel = UILabel()
    private var appScreenshot: UIImageView = UIImageView()
    private var stackView: UIStackView = UIStackView()
    
    init(title: String, subtitle: String, imageName: String) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = title
        subtitleLabel.text = subtitle
        appScreenshot.image = UIImage(named: imageName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupTitle()
        setupSubtitle()
        setupStackView()
        setupImage()
        setupLayoutConstraints()
    }
    
    private func setupTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.font = UIFont.ccFont(textStyle: .semibold, fontSize: 24)
    }
    
    private func setupImage() {
        appScreenshot.contentMode = .scaleAspectFit
        appScreenshot.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(appScreenshot)
    }
    
    private func setupSubtitle() {
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = UIFont.ccFont(textStyle: .body, fontSize: 15)
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.minimumScaleFactor = 0.5
    }
    
    private func setupStackView() {
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.distribution = .equalSpacing
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        
        view.addSubview(stackView)
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            appScreenshot.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            appScreenshot.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }
}
