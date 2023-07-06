//
//  CVDiffableViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/5/23.
//

import SwiftUI
import UIKit

private enum Section: Hashable {
    case chartSection
    case impulsesSection
}

private enum CVItem: Hashable {
    case chart
    case impulse
}

private typealias DataSource = UICollectionViewDiffableDataSource<Section, Impulse>
private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Impulse>

class CVDiffableViewController: UIViewController {
    var impulsesStateManager: ImpulsesStateManager?
    
    private(set) var collectionView: UICollectionView! = nil
    private var dataSource: DataSource! = nil
    private var snapshot: Snapshot! = nil
    
    
    private var addToCCButton: ConsciousCartButton! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        configureDataSource()
        applySnapshot()
        
        configureAddButton()
        configureLayoutConstraints()
        
        print("\(impulsesStateManager?.impulses.count)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension CVDiffableViewController {
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        collectionView.delegate = self
        
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionNumber, layoutEnvironment in
            guard let self = self else { fatalError("self could not be unwrapped.") }

//            // Section for the Savings Chart SwiftUI View.
//            if sectionNumber == 0 {
//                return savingsChartSection()
//            } else {
                // Only other case is the section for the Impulses.
                return impulseListSection(layoutEnvironment)
//            }
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
        
        listConfig.showsSeparators = false
        
        listConfig.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { [weak self] action, view, completion in
                guard let self = self else {
                    completion(false)
                    return
                }
                
                guard let identifier = dataSource.itemIdentifier(for: indexPath) else { return }
                
                let impulse = impulsesStateManager.impulses[indexPath.row]
                impulsesStateManager.deleteImpulse(impulse: impulse)

                snapshot.deleteItems([identifier])
                dataSource.apply(snapshot)

                completion(true)
            })
            
            return .init(actions: [deleteAction])
        }
        
        let section = NSCollectionLayoutSection.list(using: listConfig, layoutEnvironment: layoutEnvironment)
        
        section.contentInsets = .init(top: CGFloat(0), leading: CGFloat(16), bottom: CGFloat(0), trailing: CGFloat(16))
        
        // This is a hack to get the Swift charts view in the collection view.
        let superHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize:
                .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(300)
                ),
            elementKind: MainCollectionViewReuseIdentifiers.savingsChartCellReuseIdentifier.rawValue,
            alignment: .top
        )
        
//        let header = NSCollectionLayoutBoundarySupplementaryItem(
//            layoutSize:
//                .init(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(60)
//                ),
//            elementKind: MainCollectionViewReuseIdentifiers.impulsesCategoryHeaderIdentifier.rawValue,
//            alignment: .topLeading
//        )

        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize:
                .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                ),
            elementKind: MainCollectionViewReuseIdentifiers.impulsesCategoryFooterIdentifier.rawValue,
            alignment: .bottom
        )
        
        section.boundarySupplementaryItems = impulsesStateManager.impulses.isEmpty ? [superHeader, footer] : [superHeader]

        return section
    }
    
    private func configureDataSource() {
        let impulseCell = UICollectionView.CellRegistration<ImpulseCollectionViewListCell, Impulse> { cell, indexPath, impulse in
            var content = UIListContentConfiguration.subtitleCell()
            content.text = impulse.wrappedName
            content.textProperties.font = UIFont.ccFont(textStyle: .title3)
            
            let remainingTime = Utils.remainingTimeMessageForDate(impulse.wrappedRemindDate)
            content.secondaryText = remainingTime.0
            
            cell.accessories = [.disclosureIndicator()]
            cell.contentConfiguration = content
        }
        
        let chartsCell = UICollectionView.SupplementaryRegistration<UICollectionViewCell>(
            elementKind: MainCollectionViewReuseIdentifiers.savingsChartCellReuseIdentifier.rawValue) { [weak self] supplementaryView, elementKind, indexPath in
                guard let self = self else { fatalError("Could not unwrap self for chart view.") }
                supplementaryView.contentConfiguration = UIHostingConfiguration {
                    SavingsChart(completedImpulses: self.impulsesStateManager?.completedImpulses ?? [Impulse]())
                }
                supplementaryView.contentView.layer.borderColor = UIColor.red.cgColor
                supplementaryView.contentView.layer.borderWidth = 1
                supplementaryView.layer.borderColor = UIColor.black.cgColor
                supplementaryView.layer.borderWidth = 1
            }
        
//        let impulseSectionHeader = UICollectionView.SupplementaryRegistration<ImpulsesCategoryHeader>(
//            elementKind: MainCollectionViewReuseIdentifiers.impulsesCategoryHeaderIdentifier.rawValue) { supplementaryView, elementKind, indexPath in }
        
        let impulseSectionFooter = UICollectionView.SupplementaryRegistration<ImpulsesCategoryNoElementsFooter>(
            elementKind: MainCollectionViewReuseIdentifiers.impulsesCategoryFooterIdentifier.rawValue) { supplementaryView, elementKind, indexPath in }
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, impulse in
            return collectionView.dequeueConfiguredReusableCell(using: impulseCell, for: indexPath, item: impulse)
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            switch kind {
//            case MainCollectionViewReuseIdentifiers.impulsesCategoryHeaderIdentifier.rawValue:
//                return collectionView.dequeueConfiguredReusableSupplementary(using: impulseSectionHeader, for: indexPath)
            case MainCollectionViewReuseIdentifiers.impulsesCategoryFooterIdentifier.rawValue:
                return collectionView.dequeueConfiguredReusableSupplementary(using: impulseSectionFooter, for: indexPath)
            case MainCollectionViewReuseIdentifiers.savingsChartCellReuseIdentifier.rawValue:
                return collectionView.dequeueConfiguredReusableSupplementary(using: chartsCell, for: indexPath)
            default:
                fatalError("Handle new supplementary view for main collection view.")
            }
        }
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        guard let impulsesStateManager = impulsesStateManager else { return }
        snapshot = Snapshot()
        snapshot.appendSections([.impulsesSection])
        snapshot.appendItems(impulsesStateManager.impulses)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension CVDiffableViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let impulsesStateManager = impulsesStateManager else { return }
//        guard indexPath.section == 1 else { return }
//        guard !impulsesStateManager.impulses.isEmpty else { return }
        guard let impulse = dataSource.itemIdentifier(for: indexPath) else { return }
        print("impulse selected")
//        let detailVC = ImpulseDetailViewController()
//        detailVC.impulse = impulsesStateManager.impulses[indexPath.row]
//
//        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        print("shouldHighlightItemAt called")
        
        guard let impulsesStateManager = impulsesStateManager else { return false }
        guard !impulsesStateManager.impulses.isEmpty else { return false }
        
        return true
    }
}

//MARK: - Configure AddToCCButton
extension CVDiffableViewController {
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
//        addToCartVC.mainCVC = self
        
        let modalController = UINavigationController(rootViewController: addToCartVC)
        navigationController?.present(modalController, animated: true)
        //                navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Configure Layout Constraints
extension CVDiffableViewController {
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
