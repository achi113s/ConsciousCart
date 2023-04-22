//
//  ViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 4/21/23.
//

import UIKit

class ViewController: UIViewController {
    var loginButton: UIButton!
    var registerButton: UIButton!

    override func loadView() {
        super.loadView()
        
        loginButton = UIButton(type: .system)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", for: .normal)
        view.addSubview(loginButton)
        
        registerButton = UIButton(type: .system)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.setTitle("Register", for: .normal)
        view.addSubview(registerButton)
        
        NSLayoutConstraint.activate([
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
        
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: registerButton.centerYAnchor, constant: -50)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

