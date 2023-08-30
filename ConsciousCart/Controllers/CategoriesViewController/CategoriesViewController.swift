//
//  CategoriesViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/10/23.
//

import CoreHaptics
import UIKit
import UniformTypeIdentifiers

class CategoriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var impulsesStateManager: ImpulsesStateManager! = nil
    
    private var collectionView: UICollectionView! = nil
    private var flowLayout = CategoriesGridLayout(cellsPerRow: 3, minimumInteritemSpacing: 5, minimumLineSpacing: 10)
    
    public var categoryChangedDelegate: CategoriesViewControllerDelegate? = nil
    public var previouslySelectedCategory: ImpulseCategory? = nil
    
    private var hapticEngine: CHHapticEngine? = nil
    
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
        collectionView.register(AddCategoryCell.self, forCellWithReuseIdentifier: AddCategoryCell.identifier)
        
        prepareLongPressToDeleteGesture()
        
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
        let numberOfCategories = impulsesStateManager.impulseCategories.count
        let extraOneForCategoryAddButton = 1
        
        let total = numberOfCategories + extraOneForCategoryAddButton
        
        return total
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        
        let numberOfCategories = impulsesStateManager.impulseCategories.count
        let extraOneForCategoryAddButton = 1
        
        let total = numberOfCategories + extraOneForCategoryAddButton
        
        // If index is the last one, use the AddCategoryCell.
        if index == total - 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddCategoryCell.identifier, for: indexPath) as? AddCategoryCell else {
                fatalError("Failed to load collection view cell.")
            }
            
            return cell
        }
        
        // Else use the normal CategoryCell.
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else {
            fatalError("Failed to load collection view cell")
        }
        
        let categoryEmoji = impulsesStateManager.impulseCategories[index].unwrappedCategoryEmoji
        let categoryName = impulsesStateManager.impulseCategories[index].unwrappedCategoryName
        
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
        if let cell = collectionView.cellForItem(at: indexPath) as? AddCategoryCell {
            let ac = UIAlertController(title: "Add Custom Category", message: "You must specify a unique category name.", preferredStyle: .alert)
            
            ac.addTextField { textField in
                textField.placeholder = "e.g. 😁"
            }
            
            ac.addTextField { textField in
                textField.placeholder = "e.g. Coffee"
            }
            
            let action = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                cell.isSelected = false
            }
            
            let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
                let emoji = ac.textFields![0].text ?? ""
                let categoryName = ac.textFields![1].text ?? ""
                
                if categoryName.trimmingCharacters(in: .whitespacesAndNewlines) != "" && emoji.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    self?.impulsesStateManager.addNewCategory(categoryEmoji: emoji, categoryName: categoryName)
                    self?.impulsesStateManager.saveImpulseCategory()
                    
                    self?.collectionView.deselectItem(at: indexPath, animated: true)
                    self?.collectionView.insertItems(at: [indexPath])
//                    self?.collectionView.reloadData()
                }
            }
            
            ac.addAction(action)
            ac.addAction(saveAction)
            
            present(ac, animated: true)
            
            return
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell {
            if let selectedCategory = impulsesStateManager.impulseCategories.first(where: { $0.categoryName == cell.getCategoryName() }) {
                categoryChangedDelegate?.categoryDidChangeTo(selectedCategory)
                return
            }
        }
    }
}

extension CategoriesViewController {
    private func prepareLongPressToDeleteGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc private func handleLongPressGesture(_ gesture: UIGestureRecognizer) {
        guard let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { return }
        
        switch gesture.state {
        case .began:
            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.allowHaptics.rawValue) {
                var hapticsPlayer = CCHapticsPlayer()
                hapticsPlayer.prepareForHaptics()
                hapticsPlayer.playSinglePointHaptic()
            }
            
            showDeleteCategoryAlertMenu(for: indexPath)
        case .possible:
            print("df")
        case .changed:
            print("df")
        case .ended:
            print("ended")
            showDeleteCategoryAlertMenu(for: indexPath)
        case .cancelled:
            print("df")
        case .failed:
            print("df")
        @unknown default:
            print("df")
        }
    }
    
    private func showDeleteCategoryAlertMenu(for indexPath: IndexPath) {
        let categoryToDelete = self.impulsesStateManager.impulseCategories[indexPath.item]
        
        let ac = UIAlertController(title: "Delete Category", message: "Are you sure you want to delete the \(categoryToDelete.unwrappedCategoryName) category?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.impulsesStateManager.deleteImpulseCategory(categoryToDelete)
            self?.impulsesStateManager.saveCategories()
            
            self?.collectionView.deleteItems(at: [indexPath])
            self?.collectionView.reloadData()
        }
        
        ac.addAction(cancelAction)
        ac.addAction(deleteAction)
        
        present(ac, animated: true)
    }
}
