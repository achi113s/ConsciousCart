////
////  MainCollectionViewController.swift
////  ConsciousCart
////
////  Created by Giorgio Latour on 6/17/23.
////
//
//import UIKit
//
//class MainCollectionViewController: UIViewController {
//    var impulsesStateManager: ImpulsesStateManager?
//
//    private(set) var collectionView: UICollectionView!
//    private var collectionViewDataSource: MainCollectionViewDataSource!
//    private var collectionViewDelegate: MainCollectionViewDelegate!
//    
//    private let addToCCButton = ConsciousCartButton()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//        setSubviewProperties()
//        addSubviewsToView()
//        setupLayoutConstraints()
//
//        navigationController?.navigationBar.prefersLargeTitles = true
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        collectionView.reloadData()
//
//        navigationController?.navigationBar.prefersLargeTitles = true
//    }
//
//    func setSubviewProperties() {
//        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: MainCollectionViewController.createLayout())
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//
//        collectionViewDataSource = MainCollectionViewDataSource(impulsesStateManager: impulsesStateManager)
//        collectionView.dataSource = collectionViewDataSource
//
//        collectionViewDelegate = MainCollectionViewDelegate(impulsesStateManager: impulsesStateManager, mainCVC: self)
//        collectionView.delegate = collectionViewDelegate
//
//        // Register cell classes
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewReuseIdentifiers.defaultCellReuseIdentifier.rawValue)
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewReuseIdentifiers.savingsChartCellReuseIdentifier.rawValue)
//
//        collectionView.register(ImpulsesCategoryHeader.self, forSupplementaryViewOfKind: MainCollectionViewReuseIdentifiers.impulsesCategoryHeaderIdentifier.rawValue, withReuseIdentifier: MainCollectionViewReuseIdentifiers.headerIdentifier.rawValue)
//        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: MainCollectionViewReuseIdentifiers.noImpulsesCellReuseIdentifier.rawValue)
//        collectionView.register(ImpulseCollectionViewListCell.self, forCellWithReuseIdentifier: MainCollectionViewReuseIdentifiers.impulseCellReuseIdentifier.rawValue)
//
//        // Add add button to the view.
//        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default)
//        addToCCButton.setImage(UIImage(systemName: "cart.badge.plus", withConfiguration: largeConfig), for: .normal)
//        addToCCButton.layer.cornerRadius = 33
//        addToCCButton.addTarget(self, action: #selector(addToConsciousCart), for: .touchUpInside)
//    }
//
//    func addSubviewsToView() {
//        view.addSubview(collectionView)
//        view.addSubview(addToCCButton)
//    }
//
//    func setupLayoutConstraints() {
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
//            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
//
//            addToCCButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
//            addToCCButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
//            addToCCButton.widthAnchor.constraint(equalToConstant: 66),
//            addToCCButton.heightAnchor.constraint(equalToConstant: 66)
//        ])
//    }
//
//    static func createLayout() -> UICollectionViewCompositionalLayout {
//        return UICollectionViewCompositionalLayout { sectionNumber, layoutEnvironment in
//            // Section for the Savings Chart SwiftUI View.
//            if sectionNumber == 0 {
//                let item = NSCollectionLayoutItem(
//                    layoutSize: .init(
//                        widthDimension: .fractionalWidth(1),
//                        heightDimension: .absolute(300)
//                    )
//                )
//
//                item.contentInsets.leading = 10
//                item.contentInsets.trailing = 10
//
//                let group = NSCollectionLayoutGroup.horizontal(
//                    layoutSize: .init(
//                        widthDimension: .fractionalWidth(1),
//                        heightDimension: .absolute(300)
//                    ),
//                    subitems: [item]
//                )
//
//                let section = NSCollectionLayoutSection(group: group)
//
//                return section
//            } else {
//                // The only other case is the section with the list of Impulses.
//                //                let item = NSCollectionLayoutItem(
//                //                    layoutSize: .init(
//                //                        widthDimension: .fractionalWidth(1),
//                //                        heightDimension: .absolute(116)
//                //                    )
//                //                )
//                //
//                //                item.contentInsets.bottom = 16
//                //
//                //                let group = NSCollectionLayoutGroup.horizontal(
//                //                    layoutSize: .init(
//                //                        widthDimension: .fractionalWidth(1),
//                //                        heightDimension: .estimated(1000)
//                //                    ),
//                //                    subitems: [item]
//                //                )
//                //
//                //                let section = NSCollectionLayoutSection(group: group)
//                //
//                //                section.contentInsets.leading = 16
//                //                section.contentInsets.trailing = 16
//                //
//                //                section.boundarySupplementaryItems = [
//                //                    .init(
//                //                        layoutSize: .init(
//                //                            widthDimension: .fractionalWidth(1),
//                //                            heightDimension: .absolute(60)
//                //                        ),
//                //                        elementKind: MainCollectionViewCellReuseIdentifiers.impulsesCategoryHeaderIdentifier.rawValue,
//                //                        alignment: .topLeading
//                //                    )
//                //                ]
//                //
//                //                return section
//
//                // Using the List Configuration
//                var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
//
//                listConfiguration.showsSeparators = false
//
//                let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, completion in
//                    guard let self = self else { return }
//
//                    print("delete action")
//                    completion(true)
//                }
//
//                listConfiguration.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
//                        .init(actions: [deleteAction])
//                }
//
//                let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnvironment)
//
//                section.contentInsets.leading = 16
//                section.contentInsets.trailing = 16
//
//                let header = NSCollectionLayoutBoundarySupplementaryItem(
//                    layoutSize:
//                        .init(
//                            widthDimension: .fractionalWidth(1),
//                            heightDimension: .absolute(60)
//                        ),
//                    elementKind: MainCollectionViewReuseIdentifiers.impulsesCategoryHeaderIdentifier.rawValue,
//                    alignment: .topLeading,
//                    absoluteOffset: CGPoint(x: 16, y: 0)
//                )
//
//                section.boundarySupplementaryItems = [header]
//
//                return section
//            }
//        }
//    }
//
//    @objc func addToConsciousCart() {
//        let addToCartVC = AddToConsciousCartViewController()
//
//        addToCartVC.impulsesStateManager = impulsesStateManager
//
//        // A reference back to this view is required in order to
//        // reload the table data because viewWillAppear is not
//        // called when a modal is dismissed.
//        addToCartVC.mainCVC = self
//
//        let modalController = UINavigationController(rootViewController: addToCartVC)
//        navigationController?.present(modalController, animated: true)
//        //                navigationController?.pushViewController(vc, animated: true)
//    }
//}
