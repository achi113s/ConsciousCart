//
//  NewMainCollectionViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/2/23.
//

import UIKit
import SPConfetti

class MainCollectionViewController: UIViewController {
    var impulsesStateManager: ImpulsesStateManager! = nil
    
    private(set) var collectionView: UICollectionView! = nil
    private var collectionViewDataSource: MainCollectionViewDataSource! = nil
    private var collectionViewDelegate: MainCollectionViewDelegate! = nil
    
    private var addToCCButton: ConsciousCartButton!
    private var testImpulseExpiredViewButton: ConsciousCartButton!
    
    convenience init(impulsesStateManager: ImpulsesStateManager) {
        self.init(nibName: nil, bundle: nil)
        self.impulsesStateManager = impulsesStateManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        view.backgroundColor = .systemBackground
        
        configureCollectionView()
        configureAddButton()
//        configureTestButton()
        configureLayoutConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode =  .always
        
        addToCCButton.setColor()
        
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
                heightDimension: .fractionalHeight(1.0)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(0.4)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: CGFloat(-12), leading: CGFloat(10), bottom: CGFloat(0), trailing: CGFloat(10))
        
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
        addToCCButton.layer.cornerRadius = view.bounds.width * 0.175 * 0.5
        addToCCButton.addTarget(self, action: #selector(addToConsciousCart), for: .touchUpInside)
        
        self.view.addSubview(addToCCButton)
    }
    
    @objc private func addToConsciousCart() {
        let addToCartVC = AddToConsciousCartViewController()

        addToCartVC.impulsesStateManager = impulsesStateManager

        let modalController = UINavigationController(rootViewController: addToCartVC)
        // this type of modal presentation forces the presentingViewController to call
        // viewWillAppear when the new one is dismissed.
        modalController.modalPresentationStyle = .fullScreen
        navigationController?.present(modalController, animated: true)
    }
    
    private func configureTestButton() {
        testImpulseExpiredViewButton = ConsciousCartButton()
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default)
        testImpulseExpiredViewButton.setImage(UIImage(systemName: "testtube.2", withConfiguration: largeConfig), for: .normal)
        testImpulseExpiredViewButton.layer.cornerRadius = view.bounds.width * 0.175 * 0.5
        testImpulseExpiredViewButton.addTarget(self, action: #selector(testView), for: .touchUpInside)
        
        self.view.addSubview(testImpulseExpiredViewButton)
//        testImpulseExpiredViewButton.isHidden = true
    }
    
    @objc private func testView() {
        let impulseExpiredVC = ImpulseExpiredViewController()
        if let impulse = impulsesStateManager?.impulses.first{
            impulseExpiredVC.impulse = impulse
        }
        impulseExpiredVC.impulsesStateManager = impulsesStateManager
        // this type of modal presentation forces the presentingViewController to call
        // viewWillAppear when the new one is dismissed.
        impulseExpiredVC.modalPresentationStyle = .fullScreen
        
        let modalController = UINavigationController(rootViewController: impulseExpiredVC)
        
        navigationController?.present(modalController, animated: true)
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
            addToCCButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.175),
            addToCCButton.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.175),
            
//            testImpulseExpiredViewButton.centerXAnchor.constraint(equalTo: addToCCButton.centerXAnchor, constant: -75),
//            testImpulseExpiredViewButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
//            testImpulseExpiredViewButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.175),
//            testImpulseExpiredViewButton.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.175)
        ])
    }
}
