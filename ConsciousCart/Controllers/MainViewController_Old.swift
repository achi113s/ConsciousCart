////
////  ViewController.swift
////  ConsciousCart
////
////  Created by Giorgio Latour on 4/21/23.
////
//
//import UIKit
//import SwiftUI
//
//class MainViewController_Old: UIViewController {
//    
//    //MARK: - Properties
//    private let impulses = [Impulse]()
//    private let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    
////    private var scrollView: UIScrollView!
//    
////    private var chartLabel: UILabel!
//    private var addToCCButton: ConsciousCartButton!
//    
//    private var impulseTableView: UITableView!
//    
//    private let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default)
//    
//    override func loadView() {
//        super.loadView()
//        
//        view.backgroundColor = .systemBackground
//        
//        setSubviewProperties()
//        addSubviewsToView()
//        setLayoutConstraints()
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        navigationController?.navigationBar.tintColor = .white
//        navigationController?.navigationBar.prefersLargeTitles = true
//    }
//    
//    //MARK: - Add View Elements and Layout Constraints
//
//    func setSubviewProperties() {
//        addToCCButton = ConsciousCartButton()
//        addToCCButton.setImage(UIImage(systemName: "cart.badge.plus", withConfiguration: largeConfig), for: .normal)
//        addToCCButton.layer.cornerRadius = 35
//        addToCCButton.translatesAutoresizingMaskIntoConstraints = false
//        addToCCButton.addTarget(self, action: #selector(addToConsciousCart), for: .touchUpInside)
//        
////        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
////        scrollView.translatesAutoresizingMaskIntoConstraints = false
////        scrollView.delegate = self
//////        scrollView.backgroundColor = .brown
////        scrollView.minimumZoomScale = 1.0
////        scrollView.maximumZoomScale = 1.0
//        
////        chartLabel = UILabel()
////        chartLabel.translatesAutoresizingMaskIntoConstraints = false
////        chartLabel.text = "💸 Saved"
////        chartLabel.font = .systemFont(ofSize: 18)
//        
//        impulseTableView = UITableView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        impulseTableView.rowHeight = 50
//        impulseTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        impulseTableView.dataSource = self
//        impulseTableView.delegate = self
////        impulseTableView.translatesAutoresizingMaskIntoConstraints = false
////        impulseTableView.layer.borderColor = UIColor.black.cgColor
////        impulseTableView.layer.borderWidth = 2
//    }
//    
//    func addSubviewsToView() {
////        scrollView.addSubview(chartLabel)
////        loadSwiftUIChart()
////        scrollView.addSubview(impulseTableView)
////        view.addSubview(scrollView)
//        view.addSubview(impulseTableView)
////        view.addSubview(addToCCButton)
//        
//    }
//
//    func setLayoutConstraints() {
//        NSLayoutConstraint.activate([
////            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
////            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
////            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
////            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
////
////            chartLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
////            chartLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
//            
////            impulseTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
////            impulseTableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
////            impulseTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            
////            addToCCButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
////            addToCCButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
////            addToCCButton.widthAnchor.constraint(equalToConstant: 70),
////            addToCCButton.heightAnchor.constraint(equalToConstant: 70)
//        ])
//    }
//    
////    func loadSwiftUIChart() {
////        let chartView = SavingsChart()
////        let hostingViewController = UIHostingController(rootView: chartView)
////
////        addChild(hostingViewController)
////
////        if let hostView = hostingViewController.view {
////            hostView.translatesAutoresizingMaskIntoConstraints = false
////
////            scrollView.addSubview(hostView)
////
//////            hostView.layer.borderColor = UIColor.black.cgColor
//////            hostView.layer.borderWidth = 1
////
////            NSLayoutConstraint.activate([
////                hostView.topAnchor.constraint(equalTo: chartLabel.bottomAnchor),
////                hostView.heightAnchor.constraint(equalToConstant: 210),
////                hostView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
////                hostView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
////            ])
////        }
////    }
//    
//    //MARK: - Selectors
//    
//    @objc func addToConsciousCart() {
//        let vc = AddToConsciousCartViewController()
//        let modalController = UINavigationController(rootViewController: vc)
//        navigationController?.present(modalController, animated: true)
////        navigationController?.pushViewController(vc, animated: true)
//    }
//}
//
////MARK: - UIScrollViewDelegate Methods
//
//extension MainViewController: UIScrollViewDelegate {
//    
//}
//
////MARK: - UITableView Methods
//
//extension MainViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("cell for row at called")
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        
//        var config = cell.defaultContentConfiguration()
//        config.text = "Test \(indexPath.row)"
//        
//        cell.contentConfiguration = config
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("numberOfRowsInSection called")
//        return 10
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Selected \(indexPath.row)")
//    }
//    
//    
//}
