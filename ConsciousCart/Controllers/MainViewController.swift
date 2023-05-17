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
        impulseTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        impulseTableView.dataSource = self
        impulseTableView.delegate = self
        impulseTableView.backgroundColor = .systemBackground
//        loadSwiftUIChart()
    }
    
    func addSubviewsToView() {
        view.addSubview(impulseTableView)
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            impulseTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            impulseTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            impulseTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            impulseTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
//    func loadSwiftUIChart() {
//        let chartView = SavingsChart()
//        let hostingViewController = UIHostingController(rootView: chartView)
//
//        //        addChild(hostingViewController)
//
//        if let hostView = hostingViewController.view {
//            hostView.translatesAutoresizingMaskIntoConstraints = false
//
////            view.addSubview(hostView)
//
//            //            hostView.layer.borderColor = UIColor.black.cgColor
//            //            hostView.layer.borderWidth = 1
//
////            NSLayoutConstraint.activate([
////                hostView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
////                hostView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
////                hostView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
////                hostView.heightAnchor.constraint(equalToConstant: 210)
////            ])
//
//
//            impulseTableView.tableHeaderView = hostView
//            impulseTableView.sectionHeaderHeight = 210
//        }
//    }
}

//MARK: - UITableView Methods

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var config = cell.defaultContentConfiguration()
        config.text = "Test \(indexPath.row)"
        
        cell.contentConfiguration = config
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected \(indexPath.row)")
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
