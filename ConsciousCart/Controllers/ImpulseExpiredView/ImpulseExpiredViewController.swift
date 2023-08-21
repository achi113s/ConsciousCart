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
    
    var impulsesStateManager: ImpulsesStateManager! = nil
    var impulse: Impulse! = nil
    
    private var scoreLabel: UILabel! = nil
    
    private var awesomeLabel: UILabel! = nil
    private var messageLabel: UILabel! = nil
    
    private var failedButton: ConsciousCartButton! = nil
    private var waitedButton: ConsciousCartButton! = nil
    private var waitedAndWillBuyButton: ConsciousCartButton! = nil
    private var saveButton: ConsciousCartButton! = nil
    private var activeOptionButton: ImpulseOutcomeButtonOptions = .allUnselected
    
    private var contentStack: UIStackView! = nil
    private var buttonOptionsStack: UIStackView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(exitView))
        
        navigationItem.title = impulse.unwrappedName
        
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
        
        let daysWaited: Int = impulse.daysSinceCreation
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
        waitedButton.tag = ImpulseOutcomeButtonOptions.waitedButton.rawValue
        
        waitedAndWillBuyButton = ConsciousCartButton()
        waitedAndWillBuyButton.setTitle("I waited and now I'll buy it. 🤑", for: .normal)
        waitedAndWillBuyButton.addTarget(self, action: #selector(waitedAndWillBuyButtonPressed), for: .touchUpInside)
        waitedAndWillBuyButton.tag = ImpulseOutcomeButtonOptions.waitedAndWillBuyButton.rawValue
        
        failedButton = ConsciousCartButton()
        failedButton.setTitle("I bought it... 😭", for: .normal)
        failedButton.addTarget(self, action: #selector(failedButtonPressed), for: .touchUpInside)
        failedButton.tag = ImpulseOutcomeButtonOptions.failedButton.rawValue
        
        saveButton = ConsciousCartButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
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
    private enum ImpulseOutcomeButtonOptions: Int {
        case allUnselected = -1
        case waitedButton = 0
        case waitedAndWillBuyButton = 1
        case failedButton = 2
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
        switch activeOptionButton {
        case .allUnselected:
            saveButton.shakeAnimation()
        case .waitedButton:
            impulsesStateManager.completeImpulseWithOption(.waited, for: impulse)
            impulsesStateManager.updateUserAmountSaved(amount: impulse.price)
            simpleSuccess()
        case .waitedAndWillBuyButton:
            impulsesStateManager.completeImpulseWithOption(.waitedAndWillBuy, for: impulse)
        case .failedButton:
            impulsesStateManager.completeImpulseWithOption(.failed, for: impulse)
            impulsesStateManager.updateUserAmountSaved(amount: -impulse.price)
        }
        
        impulsesStateManager.removePendingNotification(for: impulse)
        
        impulsesStateManager.saveImpulses()
        impulsesStateManager.saveUserStats()
        
        exitView()
    }
    
    func simpleSuccess() {
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.allowHaptics.rawValue) {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
        
        SPConfettiConfiguration.particlesConfig.velocity = CGFloat(500)
        SPConfetti.startAnimating(.centerWidthToDown, particles: [.arc], duration: 1)
    }
    
    private func changeActiveOption(pressedButton: ImpulseOutcomeButtonOptions) {
        switch pressedButton {
        case .waitedButton:
            failedButton.backgroundColor = .gray
            waitedAndWillBuyButton.backgroundColor = .gray
            
            scoreLabel.countAnimation(upto: impulse?.price ?? 0.0)
            scoreLabel.textColor = .systemGreen
            
            activeOptionButton = .waitedButton
        case .waitedAndWillBuyButton:
            waitedButton.backgroundColor = .gray
            failedButton.backgroundColor = .gray
            
            scoreLabel.countAnimation(upto: 0.0)
            scoreLabel.textColor = .systemGreen
            
            activeOptionButton = .waitedAndWillBuyButton
        case .failedButton:
            waitedButton.backgroundColor = .gray
            waitedAndWillBuyButton.backgroundColor = .gray
            
            scoreLabel.countAnimation(upto: ((impulse?.price ?? 0.0) * -1))
            scoreLabel.textColor = .systemRed
            
            activeOptionButton = .failedButton
        case .allUnselected:
            waitedButton.backgroundColor = .gray
            waitedAndWillBuyButton.backgroundColor = .gray
            failedButton.backgroundColor = .gray
            
            scoreLabel.countAnimation(upto: impulse?.price ?? 0.0)
            scoreLabel.textColor = .systemGreen
            
            activeOptionButton = .allUnselected
        }
    }
}
