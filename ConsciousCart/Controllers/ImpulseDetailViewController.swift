//
//  ImpulseDetailViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 5/19/23.
//

import UIKit

class ImpulseDetailViewController: UIViewController {
    var impulse: Impulse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.title = impulse?.name ?? "Impulse"
        navigationItem.largeTitleDisplayMode = .never
    }
}
