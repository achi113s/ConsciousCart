//
//  CategoriesViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/10/23.
//

import UIKit

class CategoriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var collectionView: UICollectionView! = nil
    private var flowLayout = CategoriesGridLayout(cellsPerRow: 3, minimumInteritemSpacing: 5, minimumLineSpacing: 10)
    
    public var categoryChangedDelegate: CategoriesViewControllerDelegate? = nil
    public var previouslySelectedCategory: ImpulseCategory? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        title = "Categories"
        
        prepareCollectionView()
    }
    
    private func prepareCollectionView() {
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.alwaysBounceVertical = true
        collectionView.indicatorStyle = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImpulseCategory.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else {
            fatalError("Failed to load collection view cell")
        }
        
        let index = indexPath.row
        
        let categoryEmoji = ImpulseCategory.allCases[index].categoryEmoji
        let categoryName = ImpulseCategory.allCases[index].categoryName
        
        cell.setEmojiTo(categoryEmoji)
        cell.setCategoryNameTo(categoryName)
        
        if let previouslySelectedCategory = previouslySelectedCategory {
            if previouslySelectedCategory.categoryName == categoryName {
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
                cell.isSelected = true
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell else { return }
        
        if let selectedCategory = ImpulseCategory.allCases.first(where: { $0.categoryName == cell.getCategoryName() }) {
            categoryChangedDelegate?.categoryDidChangeTo(selectedCategory)
        }
    }
}

