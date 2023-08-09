//
//  WelcomeViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/5/23.
//

import UIKit

class UsernameOnboardingViewController: UIViewController {
    var impulsesStateManager: ImpulsesStateManager! = nil
    
    private var titleLabel: UILabel! = nil
    private var subtitleLabel: UILabel! = nil
    private var stackView: UIStackView! = nil
    private var usernameStackView: UIStackView! = nil
    
    private var usernameTextField: ConsciousCartTextField! = nil
    private var textFieldSubtitle: UILabel! = nil
    private var submitUsernameButton: SubmitUsernameButton! = nil
    
    private var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupViews()
        
        initializeHideKeyboardOnTap()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddToConsciousCartViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddToConsciousCartViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupViews() {
        setupTitle()
        setupSubtitle()
        setupTextField()
        setupTextFieldSubtitle()
        setupSubmitUsernameButton()
        setupStackViews()
        setupLayoutConstraints()
    }
    
    private func setupTitle() {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.font = UIFont.ccFont(textStyle: .semibold, fontSize: 38)
        titleLabel.text = "One last thing."
    }
    
    private func setupSubtitle() {
        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = UIFont.ccFont(textStyle: .body, fontSize: 20)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.minimumScaleFactor = 0.5
        subtitleLabel.text = "What should we call you?"
    }
    
    private func setupTextField() {
        usernameTextField = ConsciousCartTextField()
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.delegate = self
    }
    
    private func setupTextFieldSubtitle() {
        textFieldSubtitle = UILabel()
        textFieldSubtitle.translatesAutoresizingMaskIntoConstraints = false
        textFieldSubtitle.textAlignment = .center
        textFieldSubtitle.numberOfLines = 0
        textFieldSubtitle.font = UIFont.ccFont(textStyle: .body, fontSize: 12)
        textFieldSubtitle.textColor = .secondaryLabel
        textFieldSubtitle.adjustsFontSizeToFitWidth = true
        textFieldSubtitle.minimumScaleFactor = 0.5
        textFieldSubtitle.text = """
        \nYour username will be used to personalize the app experience. \
        It can be anything \
        using letters or numbers and between 3 and 10 characters long. You \
        can change it later.
        """
    }
    
    private func setupSubmitUsernameButton() {
        submitUsernameButton = SubmitUsernameButton()
        submitUsernameButton.setTitle("Submit", for: .normal)
        submitUsernameButton.addTarget(self, action: #selector(submitUsername), for: .touchUpInside)
    }
    
    private func setupStackViews() {
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 25
        stackView.distribution = .equalSpacing
        
        usernameStackView = UIStackView()
        usernameStackView.axis = .horizontal
        usernameStackView.translatesAutoresizingMaskIntoConstraints = false
        usernameStackView.spacing = 10
        usernameStackView.alignment = .center
        usernameStackView.distribution = .equalSpacing
        usernameStackView.addArrangedSubview(usernameTextField)
        usernameStackView.addArrangedSubview(submitUsernameButton)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(usernameStackView)
        stackView.addArrangedSubview(textFieldSubtitle)
        
        view.addSubview(stackView)
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            submitUsernameButton.widthAnchor.constraint(equalToConstant: 80),
            usernameTextField.heightAnchor.constraint(equalTo: submitUsernameButton.heightAnchor),
            usernameTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6)
        ])
    }
    
    @objc func submitUsername() {
        if activeTextField != nil {
            usernameTextField.resignFirstResponder()
        }
        
        // check username
        guard let testUsername = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        let isUsernameValid = checkUserNameInput(testUsername)
        
        if isUsernameValid == true {
            saveNewUsername(testUsername)
            navigateToMainScreen()
        } else {
            submitUsernameButton.shakeAnimation()
        }
    }
    
    private func checkUserNameInput(_ newUserName: String) -> Bool {
        // Username Requirements
        // - Only letters and numbers.
        // - Length must be between 3 and 10 characters.
        
        let userNameContainsInvalidChars = !newUserName.isAlphanumeric()
        let userNameLengthBad = newUserName.count > 10 || newUserName.count < 3
        
        if !userNameContainsInvalidChars && !userNameLengthBad {
            return true
        } else if userNameContainsInvalidChars && !userNameLengthBad {
            return false
        } else if userNameLengthBad && !userNameContainsInvalidChars {
            return false
        } else {
            return false
        }
    }
    
    private func saveNewUsername(_ newUserName: String) {
        guard let impulsesStateManager = impulsesStateManager else { return }
        
        impulsesStateManager.updateUserName(to: newUserName)
    }
    
    private func navigateToMainScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                let mainUICreator = CreateMainUI()
                mainUICreator.impulsesStateManager = self.impulsesStateManager
                
                let mainScreen = mainUICreator.createUI()
                sceneDelegate.window?.rootViewController = mainScreen
                sceneDelegate.window?.makeKeyAndVisible()
            }
        }
    }
}

//MARK: - UITextFieldDelegate
extension UsernameOnboardingViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

//MARK: - Keyboard Will Show
extension UsernameOnboardingViewController {
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if let activeTextField = activeTextField {
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
            
            if bottomOfTextField > topOfKeyboard {
                self.view.frame.origin.y = (bottomOfTextField - topOfKeyboard / 1.5) * -1
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
}
