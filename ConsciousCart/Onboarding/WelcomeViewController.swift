//
//  WelcomeViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/5/23.
//

import UIKit

class WelcomeViewController: UIViewController {
    private var welcomeLabel: UILabel! = nil
    private var welcomeSubtitle: UILabel! = nil
    private var appScreenshot: UIImageView! = nil
    private var stackView: UIStackView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        setupWelcomeMessage()
        setupSubtitle()
        setupImage()
        setupStackView()
        setupLayoutConstraints()
    }
    
    private func setupWelcomeMessage() {
        welcomeLabel = UILabel()
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.textAlignment = .center
        welcomeLabel.numberOfLines = 1
        welcomeLabel.adjustsFontSizeToFitWidth = true
        welcomeLabel.minimumScaleFactor = 0.5
        
        let welcomeToString: String = "Welcome to "
        let welcomeToAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.ccFont(textStyle: .semibold, fontSize: 36)
        ]
        let CCString: String = "ConsciousCart"
        let CCAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.ccFont(textStyle: .bold, fontSize: 36),
            .foregroundColor: UIColor(named: "ExodusFruit")!
        ]
        let attributedString1 = NSAttributedString(string: welcomeToString, attributes: welcomeToAttrs)
        let attributedString2 = NSAttributedString(string: CCString, attributes: CCAttrs)
        let attributedString = NSMutableAttributedString()
        attributedString.append(attributedString1)
        attributedString.append(attributedString2)
        
        welcomeLabel.attributedText = attributedString
    }
    
    private func setupImage() {
        appScreenshot = UIImageView()
        let image = UIImage(named: "homePageScreenShot")
        appScreenshot.contentMode = .scaleAspectFit
        appScreenshot.image = image
        appScreenshot.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupSubtitle() {
        welcomeSubtitle = UILabel()
        welcomeSubtitle.translatesAutoresizingMaskIntoConstraints = false
        welcomeSubtitle.textAlignment = .center
        welcomeSubtitle.numberOfLines = 0
        welcomeSubtitle.font = UIFont.ccFont(textStyle: .body)
        welcomeSubtitle.adjustsFontSizeToFitWidth = true
        welcomeSubtitle.minimumScaleFactor = 0.5
        
        welcomeSubtitle.text = """
        ConsciousCart is your delayed gratification companion.
        Save your wants and we'll remind you about them later.
        """
    }
    
    private func setupStackView() {
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.distribution = .equalSpacing
        
        stackView.addArrangedSubview(welcomeLabel)
        stackView.addArrangedSubview(welcomeSubtitle)
        stackView.addArrangedSubview(appScreenshot)
        
        view.addSubview(stackView)
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            
            appScreenshot.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        ])
    }
}
