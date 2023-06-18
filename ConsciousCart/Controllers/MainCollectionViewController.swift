//
//  MainCollectionViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 6/17/23.
//

import CoreData
import SwiftUI
import UIKit



class MainCollectionViewController: UICollectionViewController {
    
    private let impulsesTableViewDelegate = ImpulseTableViewDelegate()
    
    static let categoryHeaderId = "categoryHeaderId"
    private let headerId = "headerId"
    
    private let reuseIdentifier = "cell"
    private let impulsesCollectionViewReuseIdentifier = "impulsesCollectionViewCell"
    
    var completedImpulses = [Impulse]()
    var impulses = [Impulse]()
   
    private let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init() {
        super.init(collectionViewLayout: MainCollectionViewController.createLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionNumber, _ in
            if sectionNumber == 0 {
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                
                item.contentInsets.leading = 10
                item.contentInsets.trailing = 10
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(260)
                    ),
                    subitems: [item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
            } else {
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
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
    
    override func loadView() {
        super.loadView()
        
        loadImpulses()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView!.register(ImpulsesCollectionViewCell.self, forCellWithReuseIdentifier: impulsesCollectionViewReuseIdentifier)
        self.collectionView!.register(Header.self, forSupplementaryViewOfKind: MainCollectionViewController.categoryHeaderId, withReuseIdentifier: headerId)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Return 2 for the number of sections, one for the SwiftUI Chart and one for the list of Impulses.
        return 2
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: reuseIdentifier,
                for: indexPath
            )
            
            cell.contentConfiguration = UIHostingConfiguration {
                SavingsChart(impulses: completedImpulses)
            }
            
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: impulsesCollectionViewReuseIdentifier,
                for: indexPath
            ) as! ImpulsesCollectionViewCell
            
            cell.impulsesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            cell.impulsesTableView.delegate = impulsesTableViewDelegate
            cell.impulsesTableView.dataSource = impulsesTableViewDelegate
            cell.impulsesTableView.reloadData()
            
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
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: headerId,
            for: indexPath
        )
        
        return header
    }
    
    func loadImpulses(with request: NSFetchRequest<Impulse> = Impulse.fetchRequest()) {
        do {
            request.sortDescriptors = [NSSortDescriptor(key:"dateCreated", ascending:true)]
            let allImpulses = try moc.fetch(request)
            
            impulses = allImpulses.filter { !$0.completed }
            completedImpulses = allImpulses.filter { $0.completed }
        } catch {
            print("Error fetching data from context, \(error)")
        }
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

class ImpulsesCollectionViewCell: UICollectionViewCell {
    var impulsesTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(impulsesTableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        impulsesTableView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
}
