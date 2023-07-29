//
//  ImpulseExpiredViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/20/23.
//

import UIKit
import SPConfetti

class ImpulseExpiredViewController: UIViewController {
    
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 72, weight: .regular, scale: .default)
    
    var impulsesStateManager: ImpulsesStateManager? = nil
    var impulse: Impulse? = nil
    var mainCVC: MainCollectionViewController? = nil
    
    private var scoreLabel: UILabel! = nil
    
    private var awesomeLabel: UILabel! = nil
    private var messageLabel: UILabel! = nil
    
    private var failedButton: ConsciousCartButton! = nil
    private var waitedButton: ConsciousCartButton! = nil
    private var waitedAndWillBuyButton: ConsciousCartButton! = nil
    private var saveButton: ConsciousCartButton! = nil
    private var activeOption: Int = -1
    
    private var contentStack: UIStackView! = nil
    private var buttonOptionsStack: UIStackView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(exitView))
        
        navigationItem.title = impulse?.name ?? "Impulse"
        
        configureSubviewProperties()
        addSubviewsToView()
        configureLayoutConstraints()
    }
    
    @objc func exitView() {
        dismiss(animated: true)
    }
}

//MARK: - Configure View
extension ImpulseExpiredViewController {
    func configureSubviewProperties() {
        guard let impulse else { fatalError("No Impulse in ImpulseExpired View Controller!") }
        
        awesomeLabel = UILabel()
        awesomeLabel.translatesAutoresizingMaskIntoConstraints = false
        awesomeLabel.text = "🥳 Awesome!\nYour score is..."
        awesomeLabel.font = UIFont.ccFont(textStyle: .title)
        awesomeLabel.textAlignment = .center
        awesomeLabel.numberOfLines = 2
        
        messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        var daysWaited = 0
        if let createdDate = impulse.dateCreated {
            let components = Calendar.current.dateComponents([.day], from: createdDate, to: Date.now)
            daysWaited = components.day ?? 0
        }
        
        let dayOrDays = daysWaited == 1 ? "day" : "days"
        let messageText = "It's been \(daysWaited) \(dayOrDays) since you created an Impulse for \(impulse.unwrappedName)! Did you hold out or slip up?"
        messageLabel.text = messageText
        messageLabel.font = UIFont.ccFont(textStyle: .body)
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .center
        scoreLabel.numberOfLines = 1
        scoreLabel.text = "\(0.00)".asCurrency(locale: Locale.current) ?? "$0.00"
        scoreLabel.font = UIFont.ccFont(textStyle: .bold, fontSize: 72)
        scoreLabel.adjustsFontSizeToFitWidth = true
        scoreLabel.textColor = .systemGreen
        
        waitedButton = ConsciousCartButton()
        waitedButton.setTitle("I waited! 😁", for: .normal)
        waitedButton.addTarget(self, action: #selector(waitedButtonPressed), for: .touchUpInside)
        waitedButton.tag = ButtonTags.waitedButton.rawValue
        
        waitedAndWillBuyButton = ConsciousCartButton()
        waitedAndWillBuyButton.setTitle("I waited and now I'll buy it. 🤑", for: .normal)
        waitedAndWillBuyButton.addTarget(self, action: #selector(waitedAndWillBuyButtonPressed), for: .touchUpInside)
        waitedAndWillBuyButton.tag = ButtonTags.waitedAndWillBuyButton.rawValue
        
        failedButton = ConsciousCartButton()
        failedButton.setTitle("I bought it... 😭", for: .normal)
        failedButton.addTarget(self, action: #selector(failedButtonPressed), for: .touchUpInside)
        failedButton.tag = ButtonTags.failedButton.rawValue
        
        saveButton = ConsciousCartButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        saveButton.tag = ButtonTags.saveButton.rawValue
        
        contentStack = UIStackView()
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.alignment = .center
        contentStack.distribution = .equalSpacing
        
        buttonOptionsStack = UIStackView()
        buttonOptionsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonOptionsStack.axis = .vertical
        buttonOptionsStack.alignment = .center
        buttonOptionsStack.distribution = .equalCentering
        buttonOptionsStack.spacing = 10
    }
    
    func addSubviewsToView() {
        contentStack.addArrangedSubview(awesomeLabel)
        contentStack.addArrangedSubview(scoreLabel)
        contentStack.addArrangedSubview(messageLabel)
        
        buttonOptionsStack.addArrangedSubview(waitedButton)
        buttonOptionsStack.addArrangedSubview(waitedAndWillBuyButton)
        buttonOptionsStack.addArrangedSubview(failedButton)
        contentStack.addArrangedSubview(buttonOptionsStack)
        
        contentStack.addArrangedSubview(saveButton)
        view.addSubview(contentStack)
    }
    
    func configureLayoutConstraints() {
        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentStack.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.9),
            contentStack.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),

            waitedButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            waitedButton.heightAnchor.constraint(equalToConstant: 50),
            
            waitedAndWillBuyButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            waitedAndWillBuyButton.heightAnchor.constraint(equalToConstant: 50),
            
            failedButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            failedButton.heightAnchor.constraint(equalToConstant: 50),
            
            saveButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func returnScoreLabelColor() -> UIColor {
        return (scoreLabel.text?.asDoubleFromCurrency(locale: Locale.current) ?? 0.0) >= 0.0 ? .systemGreen : .systemRed
    }
}

//MARK: - Button Functions
extension ImpulseExpiredViewController {
    private enum ButtonTags: Int {
        case waitedButton = 0
        case waitedAndWillBuyButton = 1
        case failedButton = 2
        case saveButton = 3
    }
    
    @objc func waitedButtonPressed() {
        changeActiveOption(pressedButton: .waitedButton)
    }
    
    @objc func waitedAndWillBuyButtonPressed() {
        changeActiveOption(pressedButton: .waitedAndWillBuyButton)
    }
    
    @objc func failedButtonPressed() {
        changeActiveOption(pressedButton: .failedButton)
    }
    
    @objc func saveButtonPressed() {
        guard let impulsesStateManager = impulsesStateManager else {
            print("Error: impulsesStateManager is nil.")
            return
        }
        
        guard let impulse = impulse else { return }
        
        guard let mainCVC = mainCVC else {
            print("Error: mainCVC is nil.")
            return
        }
        
        impulse.dateCompleted = Date.now
        impulse.completed = true
        
        switch activeOption {
        case -1:
            saveButton.shakeAnimation()
        case ButtonTags.waitedButton.rawValue:
            impulse.amountSaved = impulse.price
            
            SPConfettiConfiguration.particlesConfig.velocity = CGFloat(500)
            SPConfetti.startAnimating(.centerWidthToDown, particles: [.arc], duration: 1)
            
        case ButtonTags.waitedAndWillBuyButton.rawValue:
            impulse.amountSaved = Double(0)
        case ButtonTags.failedButton.rawValue:
            impulse.amountSaved = -impulse.price
        default:
            impulse.amountSaved = Double(0)
        }
        
        impulsesStateManager.updateImpulse()
        mainCVC.collectionView.reloadData()
        simpleSuccess()
        exitView()
    }
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    private func changeActiveOption(pressedButton: ButtonTags) {
        switch pressedButton {
        case .waitedButton:
            failedButton.backgroundColor = .gray
            waitedAndWillBuyButton.backgroundColor = .gray
            
            scoreLabel.countAnimation(upto: impulse?.price ?? 0.0)
            scoreLabel.textColor = .systemGreen
            
            activeOption = ButtonTags.waitedButton.rawValue
        case .waitedAndWillBuyButton:
            waitedButton.backgroundColor = .gray
            failedButton.backgroundColor = .gray
            
            scoreLabel.countAnimation(upto: 0.0)
            scoreLabel.textColor = .systemGreen
            
            activeOption = ButtonTags.waitedAndWillBuyButton.rawValue
        case .failedButton:
            waitedButton.backgroundColor = .gray
            waitedAndWillBuyButton.backgroundColor = .gray
            
            scoreLabel.countAnimation(upto: ((impulse?.price ?? 0.0) * -1))
            scoreLabel.textColor = .systemRed
            
            activeOption = ButtonTags.failedButton.rawValue
        default:
            print("none")
        }
    }
}
