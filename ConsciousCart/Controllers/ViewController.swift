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
        loginButton.configuration = .gray()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(segueToLoginView), for: .touchUpInside)
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

    @objc func segueToLoginView(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Login") as? LoginViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

