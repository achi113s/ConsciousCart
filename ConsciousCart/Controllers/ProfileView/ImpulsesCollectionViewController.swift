//
//  ImpulsesCollectionViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/4/23.
//

import UIKit

class ImpulsesCollectionViewController: UIViewController {
    private var impulsesStateManager: ImpulsesStateManager! = nil
    private var impulseOption: ImpulseOption! = nil
    
    private var collectionView: UICollectionView! = nil
    
    private let activeCellReuse = "activeCell"
    private let pendingCellReuse = "pendingCell"
    private let completedCellReuse = "completedCell"
    
    lazy private var viewTitle: String = {
        switch impulseOption {
        case .active:
            return "Active Impulses"
        case .pending:
            return "Pending Impulses"
        case .completed:
            return "Completed Impulses"
        default:
            return ""
        }
    }()
    
    convenience init(impulsesStateManager: ImpulsesStateManager, impulseOption: ImpulseOption) {
        self.init(nibName: nil, bundle: nil)
        self.impulsesStateManager = impulsesStateManager
        self.impulseOption = impulseOption
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .black
        title = viewTitle
        
        configureCollectionView()
        addSubviews()
        configureLayoutConstraints()
    }
}

extension ImpulsesCollectionViewController {
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: <#T##CGRect#>, collectionViewLayout: <#T##UICollectionViewLayout#>)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
    }
    
    private func configureLayoutConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func impulseListSection(_ layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        var listConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        listConfig.backgroundColor = .systemBackground
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
        
        return section
    }
    
    private func registerCellClasses() {
        collectionView.register(ImpulsesCategoryHeader.self, forSupplementaryViewOfKind: MainCollectionViewReuseIdentifiers.impulsesCategoryHeaderIdentifier.rawValue, withReuseIdentifier: MainCollectionViewReuseIdentifiers.headerIdentifier.rawValue)
    }
}

// MARK: UICollectionViewDataSource

extension ImpulsesCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension ImpulsesCollectionViewController: UICollectionViewDelegate {
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
