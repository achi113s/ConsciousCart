//
//  ImpulsesTableViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/4/23.
//

import UIKit

class ImpulsesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var impulsesStateManager: ImpulsesStateManager! = nil
    private var impulseOption: ImpulseOption! = nil
    
    private var tableView: UITableView! = nil
    
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
        
        configureTableView()
        addSubviews()
        configureLayoutConstraints()
    }
}

//MARK: - Configure Subviews
extension ImpulsesTableViewController {
    private func configureTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func configureLayoutConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

//MARK: - UITableViewDataSource
extension ImpulsesTableViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch impulseOption {
        case .active:
            print("hello")
            let impulse = impulsesStateManager.impulses[indexPath.row]
            let cell = ActiveImpulseTableViewCell()
            var content = UIListContentConfiguration.subtitleCell()
            let itemPrice = String(impulse.price).asCurrency(locale: Locale.current) ?? "$0.00"
            content.text = "\(impulse.unwrappedName), \(itemPrice)"
            content.textProperties.font = UIFont.ccFont(textStyle: .bold, fontSize: 20)
            
            let remainingTime = Utils.remainingTimeMessageForDate(impulse.unwrappedRemindDate)
            content.secondaryText = remainingTime.0
            content.secondaryTextProperties.font = UIFont.ccFont(textStyle: .regular, fontSize: 12)
            
            cell.contentConfiguration = content
            cell.accessoryType = .disclosureIndicator
            
            cell.backgroundColor = .systemBackground
            
            return cell
        case .pending:
            return PendingImpulseTableViewCell()
        case .completed:
            return CompletedImpulseTableViewCell()
        default:
            return UITableViewCell()
        }
    }
}

//MARK: - UITableViewDelegate
extension ImpulsesTableViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected \(indexPath.row)")
    }
}
