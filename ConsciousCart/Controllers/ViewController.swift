//
//  ViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 4/21/23.
//

import UIKit

class ViewController: UIViewController {
    
    var addToCCButton: ConsciousCartButton!

    override func loadView() {
        super.loadView()
        
        addToCCButton = ConsciousCartButton()
        addToCCButton.setImage(UIImage(systemName: "cart.badge.plus"), for: .normal)
//        addToCCButton.imageView?.contentMode = .scaleToFill
        addToCCButton.layer.cornerRadius = 35
        addToCCButton.translatesAutoresizingMaskIntoConstraints = false
        addToCCButton.addTarget(self, action: #selector(addToConsciousCart), for: .touchUpInside)
        view.addSubview(addToCCButton)
        
        NSLayoutConstraint.activate([
            addToCCButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -60),
            addToCCButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            addToCCButton.widthAnchor.constraint(equalToConstant: 70),
            addToCCButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
        title = "ConsciousCart"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func addToConsciousCart() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddToConsciousCartView") as? AddToConsciousCartViewController {
            let modalController = UINavigationController(rootViewController: vc)
            navigationController?.present(modalController, animated: true)
        }
    }
}

