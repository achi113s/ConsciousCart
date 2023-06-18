//
//  ImpulseTableViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 6/18/23.
//

import CoreData
import UIKit

class ImpulseTableViewDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {

    // Closure used to initiate push to another view from the table view.
    var selectedImpulse: ((Int) -> ())? = .none
    
    override init() {
        super.init()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = "Cell #\(indexPath.row)"
        
        cell.contentConfiguration = content
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedImpulse?(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
