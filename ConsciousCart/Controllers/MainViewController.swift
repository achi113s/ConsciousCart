//
//  ViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 4/21/23.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController {
    
    //MARK: - Properties
    private let impulses = [Impulse]()
    private let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var impulseTableView: UITableView!
    private var addToCCButton: ConsciousCartButton!
    
    private let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default)
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .systemBackground
        
        setSubviewProperties()
        addSubviewsToView()
        setLayoutConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //MARK: - Add View Elements and Layout Constraints
    
    func setSubviewProperties() {
        impulseTableView = UITableView(frame: .zero, style: .grouped)
        impulseTableView.translatesAutoresizingMaskIntoConstraints = false
        impulseTableView.register(ImpulseTableViewCell.self, forCellReuseIdentifier: "cell")
        impulseTableView.separatorStyle = .none
        impulseTableView.dataSource = self
        impulseTableView.delegate = self
        impulseTableView.backgroundColor = .systemBackground
        
        addToCCButton = ConsciousCartButton()
        addToCCButton.setImage(UIImage(systemName: "cart.badge.plus", withConfiguration: largeConfig), for: .normal)
        addToCCButton.layer.cornerRadius = 35
        addToCCButton.addTarget(self, action: #selector(addToConsciousCart), for: .touchUpInside)
    }
    
    func addSubviewsToView() {
        view.addSubview(impulseTableView)
        view.addSubview(addToCCButton)
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            impulseTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            impulseTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            impulseTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            impulseTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            addToCCButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            addToCCButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            addToCCButton.widthAnchor.constraint(equalToConstant: 70),
            addToCCButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    @objc func addToConsciousCart() {
        let vc = AddToConsciousCartViewController()
        let modalController = UINavigationController(rootViewController: vc)
        navigationController?.present(modalController, animated: true)
        //        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UITableView Delegate, Data Source Methods

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ImpulseTableViewCell else {
            fatalError("Could not load ImpulseTableViewCell")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let chartView = SavingsChart()
        let hostingViewController = UIHostingController(rootView: chartView)
        
        addChild(hostingViewController)
        
        guard let hostView = hostingViewController.view else { return nil }
        hostView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width-40, height: 200)
        
        return hostView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 220
    }
}
