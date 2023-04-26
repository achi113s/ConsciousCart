//
//  AddToCartViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 4/25/23.
//

import UIKit

class AddToConsciousCartViewController: UIViewController {
    
    var saveButton: ConsciousCartButton!
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .white
        
        saveButton = ConsciousCartButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveItem), for: .touchUpInside)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
            saveButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(exitAddView))
    }
    
    @objc func saveItem() {
        print("save")
    }
    
    @objc func exitAddView() {
        dismiss(animated: true)
    }
}
