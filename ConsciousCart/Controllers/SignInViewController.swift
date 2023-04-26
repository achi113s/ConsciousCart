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
    var signInButton: ConsciousCartButton!
    var forgotPasswordButton: ConsciousCartButton!
    
    override func loadView() {
        super.loadView()
        
        signInLabel = UILabel()
        signInLabel.translatesAutoresizingMaskIntoConstraints = false
        signInLabel.text = "Sign In"
        signInLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        view.addSubview(signInLabel)
        
        emailField = UITextField()
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.placeholder = "Email"
        emailField.keyboardType = .emailAddress
        emailField.delegate = self
        emailField.autocorrectionType = .no
        emailField.borderStyle = .roundedRect
        view.addSubview(emailField)
        
        passwordField = UITextField()
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.placeholder = "Password"
        passwordField.autocorrectionType = .no
        passwordField.isSecureTextEntry = true
        passwordField.delegate = self
        view.addSubview(passwordField)
        
        signInButton = ConsciousCartButton()
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.addTarget(self, action: #selector(signInUser), for: .touchUpInside)
        view.addSubview(signInButton)
        
        forgotPasswordButton = ConsciousCartButton()
        forgotPasswordButton.setTitle("Forgot Password", for: .normal)
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(forgotPasswordButton)
    
        NSLayoutConstraint.activate([
            signInLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),

            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 15),

            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 15),
            signInButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            
            forgotPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forgotPasswordButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 15),
            forgotPasswordButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func signInUser(_ sender: ConsciousCartButton) {
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else { return }
        
//        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
//          guard let strongSelf = self else { return }
//            if let e = error {
//                print(e.localizedDescription)
//            } else {
//                print("Successfully logged in!")
//            }
//        }
    }
}
