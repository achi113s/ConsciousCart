//
//  ViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 4/21/23.
//

import UIKit

class ViewController: UIViewController {
    
    var logoLabel: UILabel!
    
    var loginButtonsStack: UIStackView!
    var loginButton: UIButton!
    var registerButton: UIButton!

    override func loadView() {
        super.loadView()
        
        loginButton = UIButton(type: .system)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.configuration = .gray()
        loginButton.configuration?.title = "Login"
//        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 48)
        loginButton.addTarget(self, action: #selector(goToLoginView), for: .touchUpInside)
//        view.addSubview(loginButton)
        
        registerButton = UIButton(type: .system)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.configuration = .gray()
        registerButton.configuration?.title = "Register"
//        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        registerButton.addTarget(self, action: #selector(goToRegistrationView), for: .touchUpInside)
//        view.addSubview(registerButton)
        
        loginButtonsStack = UIStackView()
        loginButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        loginButtonsStack.axis = .vertical
        loginButtonsStack.spacing = 15
        loginButtonsStack.distribution = .fillEqually
        loginButtonsStack.addArrangedSubview(loginButton)
        loginButtonsStack.addArrangedSubview(registerButton)
        view.addSubview(loginButtonsStack)
        
        logoLabel = UILabel()
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        logoLabel.text = "ConsciousCart"
        logoLabel.font = UIFont.systemFont(ofSize: 48)
        view.addSubview(logoLabel)
        
        
        
        NSLayoutConstraint.activate([
//            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            registerButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
//            registerButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
//            registerButton.heightAnchor.constraint(equalToConstant: 50),
//
//            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            loginButton.centerYAnchor.constraint(equalTo: registerButton.centerYAnchor, constant: -50),
//            loginButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
//            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            loginButtonsStack.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            loginButtonsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
            loginButtonsStack.heightAnchor.constraint(equalToConstant: 115),
            loginButtonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @objc func goToLoginView(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "LoginView") as? LoginViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func goToRegistrationView(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "RegistrationView") as? RegistrationViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

