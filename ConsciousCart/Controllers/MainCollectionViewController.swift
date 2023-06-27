//
//  MainCollectionViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 6/17/23.
//

import CoreData
import SwiftUI
import UIKit

class MainCollectionViewController: UIViewController {
    
    private(set) var collectionView: UICollectionView!
    
    //    private var impulsesTableViewDelegate: ImpulseTableViewDelegate!
    //    var impulsesTableViewCell: ImpulsesCollectionViewCell?
    
    static let categoryHeaderId = "categoryHeaderId"
    private let headerId = "headerId"
    private let reuseIdentifier = "cell"
    
    var completedImpulses = [Impulse]()
    var impulses = [Impulse]()
    
    private let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let addToCCButton = ConsciousCartButton()
    private let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImpulses()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setSubviewProperties()
        addSubviewsToView()
        setupLayoutConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadImpulses()
        collectionView.reloadData()
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setSubviewProperties() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: MainCollectionViewController.createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Register cell classes
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ImpulseCollectionViewCell.self, forCellWithReuseIdentifier: ImpulseCollectionViewCell.reuseIdentifier)
        collectionView.register(Header.self, forSupplementaryViewOfKind: MainCollectionViewController.categoryHeaderId, withReuseIdentifier: headerId)
        
        // Add add button to the view.
        addToCCButton.setImage(UIImage(systemName: "cart.badge.plus", withConfiguration: largeConfig), for: .normal)
        addToCCButton.layer.cornerRadius = 33
        addToCCButton.addTarget(self, action: #selector(addToConsciousCart), for: .touchUpInside)
    }
    
    func addSubviewsToView() {
        view.addSubview(collectionView)
        view.addSubview(addToCCButton)
        print(FileManager.documentsDirectory)
    }
    
    func setupLayoutConstraints() {
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
    
    @objc func addToConsciousCart() {
        let vc = AddToConsciousCartViewController()
        
        vc.moc = self.moc
        vc.mainCVC = self
        
        let modalController = UINavigationController(rootViewController: vc)
        navigationController?.present(modalController, animated: true)
        //        navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadImpulses() {
        (impulses, completedImpulses) = ImpulseDataManager.loadImpulses(moc: moc)
    }
}

extension MainCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    //MARK: - Collection View Layout Creator
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionNumber, _ in
            if sectionNumber == 0 {
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
            } else {
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(116)
                    )
                )
                
                item.contentInsets.bottom = 16
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .estimated(1000)
                    ),
                    subitems: [item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.contentInsets.leading = 16
                section.contentInsets.trailing = 16
                
                section.boundarySupplementaryItems = [
                    .init(
                        layoutSize: .init(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(60)
                        ),
                        elementKind: categoryHeaderId,
                        alignment: .topLeading
                    )
                ]
                
                return section
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Return 2 for the number of sections, one for the SwiftUI Chart and one for the list of Impulses.
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            if impulses.isEmpty {
                return 1
            } else {
                return impulses.count
            }
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: reuseIdentifier,
                for: indexPath
            )
            
            cell.contentConfiguration = UIHostingConfiguration {
//                SavingsChart(completedImpulses: completedImpulses)
                NewSavingsChart(completedImpulses: completedImpulses)
            }
            
            return cell
        } else if indexPath.section == 1 {
            // Show a placeholder view if there's no Impulse data to show in the table.
            if impulses.isEmpty {
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: reuseIdentifier,
                    for: indexPath
                )
                
                cell.contentView.addSubview(ZeroImpulsesView(frame: cell.bounds))
                return cell
            }
            
            // Show the Impulses.
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ImpulseCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as! ImpulseCollectionViewCell
            
            let index = indexPath.row
//            print(index)
            
            let impulse = impulses[index]
            
            cell.itemNameLabel.text = impulse.wrappedName
            cell.itemPriceLabel.text = impulse.price.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD"))
            
            let remainingTime = Utils.remainingTimeMessageForDate(impulse.wrappedRemindDate)
            cell.remainingTimeLabel.text = remainingTime.0
            cell.remainingTimeLabel.textColor = remainingTime.1 == .aLongTime ? .black : .red
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: reuseIdentifier,
                for: indexPath
            )
            
            cell.backgroundColor = .red
            print("normal red cell was loaded")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: headerId,
            for: indexPath
        )
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        
        let detailVC = ImpulseDetailViewController()
        detailVC.impulse = impulses[indexPath.row]
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImpulseCollectionViewCell else { return }
        
        UIView.animate(withDuration: 0.5) {
            cell.insetView.backgroundColor = .lightGray
        }
        
        UIView.animate(withDuration: 0.5) {
            cell.insetView.backgroundColor = .white
        }
    }
    
    class Header: UICollectionReusableView {
        private let label = UILabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            label.text = "My Impulses"
            label.font = UIFont.ccFont(textStyle: .title2)
            
            addSubview(label)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            label.frame = bounds
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented.")
        }
    }
}
