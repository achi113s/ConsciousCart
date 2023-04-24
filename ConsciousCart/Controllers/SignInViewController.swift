//
//  LoginController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 4/22/23.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    var signInLabel: UILabel!
    var emailField: UITextField!
    var passwordField: UITextField!
    var signInButton: UIButton!
    var forgotPasswordButton: UIButton!
    
    override func loadView() {
        super.loadView()
        
        signInLabel = UILabel()
        signInLabel.translatesAutoresizingMaskIntoConstraints = false
        signInLabel.text = "Sign In"
//        view.addSubview(signInLabel)
        
        emailField = UITextField()
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.placeholder = "Email"
        emailField.keyboardType = .emailAddress
        emailField.delegate = self
        emailField.autocorrectionType = .no
        emailField.borderStyle = .roundedRect
        
//        view.addSubview(emailField)
        
        passwordField = UITextField()
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.placeholder = "Password"
        passwordField.autocorrectionType = .no
        passwordField.isSecureTextEntry = true
        passwordField.delegate = self
//        view.addSubview(passwordField)
        
        signInButton = UIButton(type: .system)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(signInButton)
        
        forgotPasswordButton = UIButton(type: .system)
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(forgotPasswordButton)
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.distribution = .fillProportionally
        stackView.addArrangedSubview(signInLabel)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(signInButton)
        stackView.addArrangedSubview(forgotPasswordButton)
        view.addSubview(stackView)
    
        NSLayoutConstraint.activate([
//            signInLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//
//            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//
//            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//
//            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//
//            forgotPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            forgotPasswordButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            stackView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.4)
        ])
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
    }
}
