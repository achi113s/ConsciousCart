//
//  ImpulseExpiredViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/20/23.
//

import UIKit

class ImpulseExpiredViewController: UIViewController {
    
    var impulse: Impulse? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(exitView))
        
        navigationItem.title = impulse?.name ?? "Impulse"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    @objc func exitView() {
        dismiss(animated: true)
    }
    
    
}
