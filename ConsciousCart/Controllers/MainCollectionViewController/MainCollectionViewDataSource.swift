//
//  MainCollectionViewDataSource.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 6/30/23.
//

import SwiftUI
import UIKit

// MARK: UICollectionViewDataSource
class MainCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var impulsesStateManager: ImpulsesStateManager?
    
    init(impulsesStateManager: ImpulsesStateManager? = nil) {
        self.impulsesStateManager = impulsesStateManager
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Return 2 for the number of sections, one for the SwiftUI Chart and one for the list of Impulses.
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            guard let impulsesStateManager = impulsesStateManager else { return 1 }
            
            if impulsesStateManager.impulses.isEmpty {
                return 1
            } else {
                return impulsesStateManager.impulses.count
            }
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let impulsesStateManager = impulsesStateManager else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MainCollectionViewCellReuseIdentifiers.defaultCellReuseIdentifier.rawValue,
                for: indexPath
            )
            
            cell.backgroundColor = .red
            print("Error red cell was loaded.")
            return cell
        }
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MainCollectionViewCellReuseIdentifiers.savingsChartCellReuseIdentifier.rawValue,
                for: indexPath
            )
            
            cell.contentConfiguration = UIHostingConfiguration {
                SavingsChart(completedImpulses: impulsesStateManager.completedImpulses)
            }
            
            return cell
        } else {
            // Show a placeholder view if there's no Impulse data to show in the table.
            if impulsesStateManager.impulses.isEmpty {
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MainCollectionViewCellReuseIdentifiers.noImpulsesCellReuseIdentifier.rawValue,
                    for: indexPath
                )
                
                cell.refreshContentView()
                
                cell.contentView.addSubview(ZeroImpulsesView(frame: cell.bounds))
                
                return cell
            } else {
                // Show the Impulses.
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MainCollectionViewCellReuseIdentifiers.impulseCellReuseIdentifier.rawValue,
                    for: indexPath
                ) as! ImpulseCollectionViewCell
                
                let index: Int = indexPath.row
                
                let impulse: Impulse = impulsesStateManager.impulses[index]
                
                cell.itemNameLabel.text = impulse.wrappedName
                print("loading impulse cell")
                print(impulse.wrappedName)
                print("number of subviews in cell's contentview: \(cell.contentView.subviews.count)")
                cell.itemPriceLabel.text = impulse.price.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD"))
                let remainingTime = Utils.remainingTimeMessageForDate(impulse.wrappedRemindDate)
                cell.remainingTimeLabel.text = remainingTime.0
                
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: MainCollectionViewCellReuseIdentifiers.headerIdentifier.rawValue,
            for: indexPath
        )
        
        return header
    }
}
