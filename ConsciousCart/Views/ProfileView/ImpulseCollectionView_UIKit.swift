////
////  ImpulseCollectionView.swift
////  ConsciousCart
////
////  Created by Giorgio Latour on 7/29/23.
////
//
//import SwiftUI
//import UIKit
//
//struct ImpulseCollectionView: UIViewControllerRepresentable {
//    typealias UIViewControllerType = UIViewController
//    
//    var impulseOption: ImpulseOption? = nil
//    var impulsesStateManager: ImpulsesStateManager? = nil
//    
//    var collectionView: UICollectionView! = nil
//    @State var collectionViewDataSource: ImpulseCollectionViewDataSource! = nil
//    @State var collectionViewDelegate: ImpulseCollectionViewDelegate! = nil
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        let collectionContainerView = UIViewController()
//        
//        let collectionView = UICollectionView(frame: collectionContainerView.view.bounds, collectionViewLayout: createLayout())
//        collectionViewDataSource = ImpulseCollectionViewDataSource()
//        collectionView.dataSource = collectionViewDataSource
//        collectionViewDelegate = ImpulseCollectionViewDelegate()
//        collectionView.delegate = collectionViewDelegate
//        
//        collectionContainerView.view.addSubview(collectionView)
//        
//        return collectionContainerView
//        
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
//    
//    private func createLayout() -> UICollectionViewCompositionalLayout {
//        return UICollectionViewCompositionalLayout { sectionNumber, layoutEnvironment in
//            return impulseListSection(layoutEnvironment)
//        }
//    }
//    
//    private func impulseListSection(_ layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
//        guard let impulsesStateManager = impulsesStateManager else { fatalError("No data manager for impulseListSection.")}
//        
//        var listConfig = UICollectionLayoutListConfiguration(appearance: .plain)
//        listConfig.backgroundColor = UIColor(named: "DefaultBackground")
//        listConfig.showsSeparators = false
//        
//        listConfig.trailingSwipeActionsConfigurationProvider = { indexPath in
//            let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { action, view, completion in
//                view.frame = .init(x: view.frame.minX, y: view.frame.minY, width: view.frame.width, height: CGFloat(150))
//                
//                let impulse = impulsesStateManager.impulses[indexPath.row]
//                impulsesStateManager.deleteImpulse(impulse: impulse)
//                
//                collectionView.deleteItems(at: [indexPath])
//
//                completion(true)
//            })
//            
//            return .init(actions: [deleteAction])
//        }
//        
//        let section = NSCollectionLayoutSection.list(using: listConfig, layoutEnvironment: layoutEnvironment)
//        
//        // THIS SETS THE SPACING BETWEEN CELLS IN THE LIST
//        section.interGroupSpacing = CGFloat(10)
//        
//        section.contentInsets = .init(top: CGFloat(0), leading: CGFloat(16), bottom: CGFloat(0), trailing: CGFloat(16))
//        
//        let header = NSCollectionLayoutBoundarySupplementaryItem(
//            layoutSize:
//                .init(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(60)
//                ),
//            elementKind: MainCollectionViewReuseIdentifiers.impulsesCategoryHeaderIdentifier.rawValue,
//            alignment: .topLeading
//        )
//        
//        let footer = NSCollectionLayoutBoundarySupplementaryItem(
//            layoutSize:
//                .init(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(60)
//                ),
//            elementKind: MainCollectionViewReuseIdentifiers.impulsesCategoryFooterIdentifier.rawValue,
//            alignment: .bottom
//        )
//        
//        section.boundarySupplementaryItems = impulsesStateManager.impulses.isEmpty ? [header, footer] : [header]
//        return section
//    }
//}
