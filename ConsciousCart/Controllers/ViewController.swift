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
    var loginButton: CCNormalButton!
    var registerButton: UIButton!

    override func loadView() {
        super.loadView()
        
        loginButton = CCNormalButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(goToLoginView), for: .touchUpInside)
        view.addSubview(loginButton)
        
        registerButton = CCNormalButton()
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.setTitle("Register", for: .normal)
        registerButton.addTarget(self, action: #selector(goToRegistrationView), for: .touchUpInside)
        view.addSubview(registerButton)
        
        logoLabel = UILabel()
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        logoLabel.text = "ConsciousCart"
        logoLabel.font = UIFont.systemFont(ofSize: 48)
        view.addSubview(logoLabel)
        
        NSLayoutConstraint.activate([
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
            registerButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            registerButton.heightAnchor.constraint(equalToConstant: 50),

            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: registerButton.centerYAnchor, constant: -65),
            loginButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .black
    }

    @objc func goToLoginView(_ sender: CCNormalButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "LoginView") as? SignInViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func goToRegistrationView(_ sender: CCNormalButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "RegistrationView") as? RegistrationViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

