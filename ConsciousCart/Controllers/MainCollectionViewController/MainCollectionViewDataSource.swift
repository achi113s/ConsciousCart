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
        guard let impulsesStateManager else { return 0 }
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            guard let impulsesStateManager = impulsesStateManager else { return 0 }
            
            return impulsesStateManager.impulses.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let impulsesStateManager = impulsesStateManager else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MainCollectionViewReuseIdentifiers.defaultCellReuseIdentifier.rawValue,
                for: indexPath
            )
            
            cell.backgroundColor = .red
            print("Error red cell was loaded.")
            return cell
        }
        
        // Section 0 is the Savings Chart Section
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MainCollectionViewReuseIdentifiers.savingsChartCellReuseIdentifier.rawValue,
                for: indexPath
            )
            
            cell.contentConfiguration = UIHostingConfiguration {
                SavingsChart(completedImpulses: impulsesStateManager.completedImpulses)
            }
            
            return cell
        } else {
            // Show the Impulses.
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MainCollectionViewReuseIdentifiers.impulseCellReuseIdentifier.rawValue,
                for: indexPath
            ) as! ImpulseCollectionViewListCell
            
            let index: Int = indexPath.row

            let impulse: Impulse = impulsesStateManager.impulses[index]

            var content = UIListContentConfiguration.subtitleCell()
            content.text = impulse.wrappedName
            content.textProperties.font = UIFont.ccFont(textStyle: .title3)
            let remainingTime = Utils.remainingTimeMessageForDate(impulse.wrappedRemindDate)
            content.secondaryText = remainingTime.0

            cell.contentConfiguration = content
            cell.accessories = [.disclosureIndicator()]
            
//            cell.itemNameLabel.text = impulse.wrappedName
//            cell.itemPriceLabel.text = impulse.price.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD"))
//            let remainingTime = Utils.remainingTimeMessageForDate(impulse.wrappedRemindDate)
//            cell.remainingTimeLabel.text = remainingTime.0

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == MainCollectionViewReuseIdentifiers.impulsesCategoryHeaderIdentifier.rawValue {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MainCollectionViewReuseIdentifiers.headerIdentifier.rawValue,
                for: indexPath
            )
            
            return header
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MainCollectionViewReuseIdentifiers.footerIdentifier.rawValue,
                for: indexPath
            )
            
            return footer
        }
    }
}
