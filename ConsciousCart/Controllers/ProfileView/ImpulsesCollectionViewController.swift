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
    
    private let impulseCellReuse = "activeCell"
    
    private var nothingToShow: UILabel! = nil
    
    private var searchController = UISearchController()
    private var userIsSearching: Bool = false
    private var filteredImpulses: [Impulse] = []
    
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
        
        // search support
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        navigationItem.searchController = searchController
        
        configureCollectionView()
        configureSubviews()
        addSubviews()
        configureLayoutConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch impulseOption {
        case .active:
            if impulsesStateManager.impulses.count == 0 {
                nothingToShow.isHidden = false
                collectionView.isHidden = true
            }
        case .pending:
            if impulsesStateManager.pendingImpulses.count == 0 {
                nothingToShow.isHidden = false
                collectionView.isHidden = true
            }
        case .completed:
            if impulsesStateManager.completedImpulses.count == 0 {
                nothingToShow.isHidden = false
                collectionView.isHidden = true
            }
        default:
            nothingToShow.isHidden = true
            collectionView.isHidden = false
        }
        
        collectionView.reloadData()
    }
}

extension ImpulsesCollectionViewController {
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(10), right: CGFloat(0))
        collectionView.backgroundColor = .systemBackground
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        registerCellClasses()
        
        view.addSubview(collectionView)
    }
    
    private func configureSubviews() {
        nothingToShow = UILabel()
        nothingToShow.translatesAutoresizingMaskIntoConstraints = false
        nothingToShow.text = "Nothing to see here!"
        nothingToShow.font = UIFont.ccFont(textStyle: .title3)
        nothingToShow.textColor = .secondaryLabel
        nothingToShow.adjustsFontSizeToFitWidth = true
        nothingToShow.minimumScaleFactor = 0.5
        nothingToShow.numberOfLines = 1
        nothingToShow.textAlignment = .center
        nothingToShow.isHidden = true
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionNumber, layoutEnvironment in
            guard let self = self else { fatalError("Self could not be unwrapped.") }
            
            return impulseListSection(layoutEnvironment)
        }
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(nothingToShow)
    }
    
    private func configureLayoutConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            nothingToShow.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nothingToShow.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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
                
                var impulse: Impulse? = nil
                switch impulseOption {
                case .active:
                    impulse = impulsesStateManager.impulses[indexPath.row]
                    if let impulse = impulse { impulsesStateManager.deleteImpulse(impulse: impulse) }
                case .pending:
                    impulse = impulsesStateManager.pendingImpulses[indexPath.row]
                    if let impulse = impulse { impulsesStateManager.deletePendingImpulse(impulse: impulse) }
                case .completed:
                    impulse = impulsesStateManager.completedImpulses[indexPath.row]
                    if let impulse = impulse { impulsesStateManager.deleteCompletedImpulse(impulse: impulse) }
                default:
                    completion(false)
                    return
                }
                
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
        collectionView.register(ImpulseCollectionViewListCell.self, forCellWithReuseIdentifier: impulseCellReuse)
    }
}

// MARK: UICollectionViewDataSource

extension ImpulsesCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !userIsSearching {
            switch impulseOption {
            case .active:
                return impulsesStateManager.impulses.count
            case .pending:
                return impulsesStateManager.pendingImpulses.count
            case .completed:
                return impulsesStateManager.completedImpulses.count
            default:
                return 0
            }
        } else {
            return filteredImpulses.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: impulseCellReuse, for: indexPath) as! ImpulseCollectionViewListCell
        
        let index: Int = indexPath.row
        
        var content = UIListContentConfiguration.subtitleCell()
        
        
        
        switch impulseOption {
        case .active:
            var impulse: Impulse! = nil
            
            if !userIsSearching {
                impulse = impulsesStateManager.impulses[index]
            } else {
                impulse = filteredImpulses[index]
            }
            
            let itemPrice = String(impulse.price).asCurrency(locale: Locale.current) ?? "$0.00"
            content.text = "\(impulse.unwrappedName), \(itemPrice)"
            content.textProperties.font = UIFont.ccFont(textStyle: .bold, fontSize: 20)
            
            let remainingTime = Utils.remainingTimeMessageForDate(impulse.unwrappedRemindDate)
            content.secondaryText = remainingTime.0
            content.secondaryTextProperties.font = UIFont.ccFont(textStyle: .regular, fontSize: 12)
            
            var categoryLabel: UILabel! = nil
            if let category = ImpulseCategory.allCases.first(where: { $0.categoryName == impulse.unwrappedCategory }) {
                categoryLabel = UILabel()
                categoryLabel.text = category.categoryEmoji
            }
            
            if categoryLabel != nil {
                cell.accessories = [.customView(configuration: .init(customView: categoryLabel, placement: .trailing())), .disclosureIndicator()]
            } else {
                cell.accessories = [.disclosureIndicator()]
            }
        case .pending:
            var impulse: Impulse! = nil
            
            if !userIsSearching {
                impulse = impulsesStateManager.pendingImpulses[index]
            } else {
                impulse = filteredImpulses[index]
            }
            
            let itemPrice = String(impulse.price).asCurrency(locale: Locale.current) ?? "$0.00"
            content.text = "\(impulse.unwrappedName), \(itemPrice)"
            content.textProperties.font = UIFont.ccFont(textStyle: .bold, fontSize: 20)
            
            
            content.secondaryText = "⌛️ \(impulse.daysSinceExpiry) Days Overdue"
            content.secondaryTextProperties.font = UIFont.ccFont(textStyle: .regular, fontSize: 12)
            
            var categoryLabel: UILabel! = nil
            if let category = ImpulseCategory.allCases.first(where: { $0.categoryName == impulse.unwrappedCategory }) {
                categoryLabel = UILabel()
                categoryLabel.text = category.categoryEmoji
            }
            
            if categoryLabel != nil {
                cell.accessories = [.customView(configuration: .init(customView: categoryLabel, placement: .trailing())), .disclosureIndicator()]
            } else {
                cell.accessories = [.disclosureIndicator()]
            }
        case .completed:
            var impulse: Impulse! = nil
            
            if !userIsSearching {
                impulse = impulsesStateManager.completedImpulses[index]
            } else {
                impulse = filteredImpulses[index]
            }
            
            let itemPrice = String(impulse.price).asCurrency(locale: Locale.current) ?? "$0.00"
            
            var savedMessage: String = ""
            var sealColor: UIColor = .black
            
            if impulse.amountSaved == 0 {
                savedMessage = "You didn't save anything!"
            } else if impulse.amountSaved > 0 {
                savedMessage = "You saved \(itemPrice)!"
                sealColor = .systemGreen
            } else if impulse.amountSaved < 0 {
                savedMessage = "You spent \(itemPrice)!"
                sealColor = .systemRed
            }
            
            content.text = "\(impulse.unwrappedName), \(itemPrice)"
            content.textProperties.font = UIFont.ccFont(textStyle: .bold, fontSize: 20)
            
            content.secondaryText = savedMessage
            content.secondaryTextProperties.font = UIFont.ccFont(textStyle: .regular, fontSize: 12)
            
            let seal = UIImage(systemName: "checkmark.seal")?.withTintColor(sealColor, renderingMode: .alwaysOriginal)
            let sealView = UIImageView(image: seal)
            
            var categoryLabel: UILabel! = nil
            if let category = ImpulseCategory.allCases.first(where: { $0.categoryName == impulse.unwrappedCategory }) {
                categoryLabel = UILabel()
                categoryLabel.text = category.categoryEmoji
            }
            
            if categoryLabel != nil {
                cell.accessories = [.customView(configuration: .init(customView: categoryLabel, placement: .trailing())),
                                    .customView(configuration: .init(customView: sealView, placement: .trailing())),
                                    .disclosureIndicator()]
            } else {
                cell.accessories = [.customView(configuration: .init(customView: sealView, placement: .trailing())),
                                    .disclosureIndicator()]
            }
        default:
            print("No case matched.")
        }
        
        cell.contentConfiguration = content
        
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension ImpulsesCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = ImpulseDetailViewController()
        
        switch impulseOption {
        case .active:
            detailVC.impulse = impulsesStateManager.impulses[indexPath.row]
        case .pending:
            detailVC.impulse = impulsesStateManager.pendingImpulses[indexPath.row]
            detailVC.viewShowsPendingImpulses = true
        case .completed:
            detailVC.impulse = impulsesStateManager.completedImpulses[indexPath.row]
        default:
            return
        }
        
        detailVC.impulsesStateManager = impulsesStateManager
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK: - Search Results Controller
extension ImpulsesCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        userIsSearching = true
        
        if text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            userIsSearching = false
            collectionView.reloadData()
            return
        }
        
        switch impulseOption {
        case .active:
            filteredImpulses = impulsesStateManager.impulses.filter( { $0.unwrappedName.localizedCaseInsensitiveContains(text) })
        case .pending:
            filteredImpulses = impulsesStateManager.pendingImpulses.filter( { $0.unwrappedName.localizedCaseInsensitiveContains(text) })
        case .completed:
            filteredImpulses = impulsesStateManager.completedImpulses.filter( { $0.unwrappedName.localizedCaseInsensitiveContains(text) })
        default:
            return
        }
        
        collectionView.reloadData()
    }
    
    
}

extension ImpulsesCollectionViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        userIsSearching = false
        collectionView.reloadData()
    }
}
