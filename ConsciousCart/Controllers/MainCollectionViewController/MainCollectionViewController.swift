//
//  NewMainCollectionViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/2/23.
//

import UIKit

class MainCollectionViewController: UIViewController {
    var impulsesStateManager: ImpulsesStateManager?
    
    private(set) var collectionView: UICollectionView!
    private var collectionViewDataSource: MainCollectionViewDataSource!
    private var collectionViewDelegate: MainCollectionViewDelegate!
    
    private var addToCCButton: ConsciousCartButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = UIColor(named: "DefaultBackground")
        
        configureCollectionView()
        configureAddButton()
        configureLayoutConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.reloadData()
    }
}

//MARK: - Configure Collection View
extension MainCollectionViewController {
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleHeight]
        collectionView.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(10), right: CGFloat(0))
        collectionView.backgroundColor = UIColor(named: "DefaultBackground")
        
        collectionViewDataSource = MainCollectionViewDataSource(impulsesStateManager: impulsesStateManager)
        collectionView.dataSource = collectionViewDataSource
        
        collectionViewDelegate = MainCollectionViewDelegate(impulsesStateManager: impulsesStateManager, mainCVC: self)
        collectionView.delegate = collectionViewDelegate
        
        registerCellClasses()
        
        self.view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionNumber, layoutEnvironment in
            guard let self = self else { fatalError("MainCollectionViewController could not be unwrapped.") }
            
            // Section for the Savings Chart SwiftUI View.
            if sectionNumber == CVSection.chartSection.rawValue {
                return savingsChartSection()
            } else {
                // Only other case is the section for the Impulses.
                return impulseListSection(layoutEnvironment)
            }
            
        }
    }
    
    private func savingsChartSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(300)
            )
        )
        
        item.contentInsets.leading = 10
        item.contentInsets.trailing = 10
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(300)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func impulseListSection(_ layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        guard let impulsesStateManager = impulsesStateManager else { fatalError("No data manager for impulseListSection.")}
        var listConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        listConfig.backgroundColor = UIColor(named: "DefaultBackground")
        listConfig.showsSeparators = false
        
        listConfig.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { [weak self] action, view, completion in
                guard let self = self else {
                    completion(false)
                    return
                }
                
                view.frame = .init(x: view.frame.minX, y: view.frame.minY, width: view.frame.width, height: CGFloat(150))
                
                let impulse = impulsesStateManager.impulses[indexPath.row]
                impulsesStateManager.deleteImpulse(impulse: impulse)
                
                collectionView.deleteItems(at: [indexPath])

                completion(true)
            })
            
            return .init(actions: [deleteAction])
        }
        
        let section = NSCollectionLayoutSection.list(using: listConfig, layoutEnvironment: layoutEnvironment)
        
        // THIS SETS THE SPACING BETWEEN CELLS IN THE LIST
        section.interGroupSpacing = CGFloat(10)
        
        section.contentInsets = .init(top: CGFloat(0), leading: CGFloat(16), bottom: CGFloat(0), trailing: CGFloat(16))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize:
                .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                ),
            elementKind: MainCollectionViewReuseIdentifiers.impulsesCategoryHeaderIdentifier.rawValue,
            alignment: .topLeading
        )
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize:
                .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                ),
            elementKind: MainCollectionViewReuseIdentifiers.impulsesCategoryFooterIdentifier.rawValue,
            alignment: .bottom
        )
        
        section.boundarySupplementaryItems = impulsesStateManager.impulses.isEmpty ? [header, footer] : [header]
        return section
    }
    
    private func registerCellClasses() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewReuseIdentifiers.defaultCellReuseIdentifier.rawValue)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewReuseIdentifiers.savingsChartCellReuseIdentifier.rawValue)
        
        collectionView.register(ImpulsesCategoryHeader.self, forSupplementaryViewOfKind: MainCollectionViewReuseIdentifiers.impulsesCategoryHeaderIdentifier.rawValue, withReuseIdentifier: MainCollectionViewReuseIdentifiers.headerIdentifier.rawValue)
        
        collectionView.register(NoImpulsesFooter.self, forSupplementaryViewOfKind: MainCollectionViewReuseIdentifiers.impulsesCategoryFooterIdentifier.rawValue, withReuseIdentifier: MainCollectionViewReuseIdentifiers.footerIdentifier.rawValue)

        collectionView.register(ImpulseCollectionViewListCell.self, forCellWithReuseIdentifier: MainCollectionViewReuseIdentifiers.impulseCellReuseIdentifier.rawValue)
    }
}

//MARK: - Configure AddToCCButton
extension MainCollectionViewController {
    private func configureAddButton() {
        addToCCButton = ConsciousCartButton()
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default)
        addToCCButton.setImage(UIImage(systemName: "cart.badge.plus", withConfiguration: largeConfig), for: .normal)
        addToCCButton.layer.cornerRadius = 33
        addToCCButton.addTarget(self, action: #selector(addToConsciousCart), for: .touchUpInside)
        
        self.view.addSubview(addToCCButton)
    }
    
    @objc private func addToConsciousCart() {
        let addToCartVC = AddToConsciousCartViewController()
        
        addToCartVC.impulsesStateManager = impulsesStateManager
        
        // A reference back to this view is required in order to
        // reload the table data because viewWillAppear is not
        // called when a modal is dismissed.
        addToCartVC.mainCVC = self
        
        let modalController = UINavigationController(rootViewController: addToCartVC)
        navigationController?.present(modalController, animated: true)
        //                navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Configure Layout Constraints
extension MainCollectionViewController {
    private func configureLayoutConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            addToCCButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            addToCCButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            addToCCButton.widthAnchor.constraint(equalToConstant: 66),
            addToCCButton.heightAnchor.constraint(equalToConstant: 66)
        ])
    }
}
