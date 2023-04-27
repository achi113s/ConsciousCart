//
//  ViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 4/21/23.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    var addToCCButton: ConsciousCartButton!
    var chartLabel: UILabel!
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .white
        
        addToCCButton = ConsciousCartButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default)
        addToCCButton.setImage(UIImage(systemName: "cart.badge.plus", withConfiguration: largeConfig), for: .normal)
        addToCCButton.layer.cornerRadius = 35
        addToCCButton.translatesAutoresizingMaskIntoConstraints = false
        addToCCButton.addTarget(self, action: #selector(addToConsciousCart), for: .touchUpInside)
        view.addSubview(addToCCButton)
        
        chartLabel = UILabel()
        chartLabel.translatesAutoresizingMaskIntoConstraints = false
        chartLabel.text = "Total Amount Saved"
        chartLabel.font = .systemFont(ofSize: 18)
        chartLabel.textColor = .black
        view.addSubview(chartLabel)
        
        NSLayoutConstraint.activate([
            chartLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            chartLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            addToCCButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -60),
            addToCCButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            addToCCButton.widthAnchor.constraint(equalToConstant: 70),
            addToCCButton.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        loadSwiftUIChart()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        //        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func addToConsciousCart() {
        let vc = AddToConsciousCartViewController()
        let modalController = UINavigationController(rootViewController: vc)
        navigationController?.present(modalController, animated: true)
    }
    
    func loadSwiftUIChart() {
        let chartView = MyChart()
        let hostingViewController = UIHostingController(rootView: chartView)
        addChild(hostingViewController)
        if let hostView = hostingViewController.view {
            hostView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(hostView)
            NSLayoutConstraint.activate([
                hostView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
                hostView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
                hostView.topAnchor.constraint(equalTo: chartLabel.bottomAnchor),
                hostView.heightAnchor.constraint(equalToConstant: 210)
            ])
        }
    }
}

