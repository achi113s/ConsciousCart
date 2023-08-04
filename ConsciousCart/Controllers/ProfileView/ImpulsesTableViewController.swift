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
    
    convenience init(impulsesStateManager: ImpulsesStateManager, impulseOption: ImpulseOption) {
        self.init(nibName: nil, bundle: nil)
        self.impulsesStateManager = impulsesStateManager
        self.impulseOption = impulseOption
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
}

//MARK: - Configure Subviews
extension ImpulsesTableViewController {
    private func configureTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
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
        
    }
}

//MARK: - UITableViewDelegate
extension ImpulsesTableViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
}
