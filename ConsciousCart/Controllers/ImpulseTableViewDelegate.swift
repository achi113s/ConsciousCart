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
    var selectedImpulse: ((Int) -> Void)? = .none

    var impulses = [Impulse]()
    var completedImpulses = [Impulse]()

    private let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override init() {
        super.init()

        loadImpulses()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "impulseTableViewCell", for: indexPath) as? ImpulseTableViewCell else {
            fatalError("Could not load ImpulseTableViewCell")
        }

        let impulse = impulses[indexPath.row]

        cell.itemNameLabel.text = impulse.wrappedName
        cell.itemPriceLabel.text = impulse.price.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD"))

        let remainingTime = Utils.remainingTimeMessageForDate(impulse.wrappedRemindDate)
        cell.remainingTimeLabel.text = remainingTime.0
        cell.remainingTimeLabel.textColor = remainingTime.1 == .aLongTime ? .black : .red
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return impulses.count
    }

    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedImpulse?(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
