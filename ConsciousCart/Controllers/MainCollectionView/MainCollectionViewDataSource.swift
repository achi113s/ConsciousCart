//
//  MainCollectionViewDataSource.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 6/30/23.
//

import SwiftUI
import UIKit

// MARK: UICollectionViewDataSource
extension MainCollectionViewController {
    class MainCollectionViewDataSource: NSObject, UICollectionViewDataSource {
        var impulsesStateManager: ImpulsesStateManager! = nil
        
        init(impulsesStateManager: ImpulsesStateManager) {
            self.impulsesStateManager = impulsesStateManager
        }
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            // Return 2 for the number of sections, one for the SwiftUI Chart and one for the list of Impulses.
            return CVSection.allCases.count
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if section == CVSection.chartSection.rawValue {
                return 1
            } else if section == CVSection.impulseSection.rawValue {
                return impulsesStateManager.impulses.count
            } else {
                return 0
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            // Section 0 is the Savings Chart Section
            if indexPath.section == CVSection.chartSection.rawValue {
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MainCollectionViewReuseIdentifiers.savingsChartCellReuseIdentifier.rawValue,
                    for: indexPath
                )
                
                cell.contentConfiguration = UIHostingConfiguration {
                    SavingsChart(impulsesStateManager: impulsesStateManager)
                }
                
                return cell
            } else if indexPath.section == CVSection.impulseSection.rawValue {
                // Show the Impulses.
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MainCollectionViewReuseIdentifiers.impulseCellReuseIdentifier.rawValue,
                    for: indexPath
                ) as! ImpulseCollectionViewListCell
                
                let index: Int = indexPath.row
                
                let impulse: Impulse = impulsesStateManager.impulses[index]
                
                var content = UIListContentConfiguration.subtitleCell()
                let itemPrice = String(impulse.price).asCurrency(locale: Locale.current) ?? "$0.00"
                content.text = "\(impulse.unwrappedName), \(itemPrice)"
                content.textProperties.font = UIFont.ccFont(textStyle: .title3)
                
                let remainingTime = Utils.remainingTimeMessageForDate(impulse.unwrappedRemindDate)
                content.secondaryText = remainingTime.0
                
                cell.contentConfiguration = content
                
                var categoryLabel: UILabel! = nil
                if let category = impulsesStateManager.impulseCategories.first(where: { $0.categoryName == impulse.unwrappedCategory }) {
                    categoryLabel = UILabel()
                    categoryLabel.text = category.categoryEmoji
                }
                
                if categoryLabel != nil {
                    cell.accessories = [.customView(configuration: .init(customView: categoryLabel, placement: .trailing())), .disclosureIndicator()]
                } else {
                    cell.accessories = [.disclosureIndicator()]
                }
                
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MainCollectionViewReuseIdentifiers.defaultCellReuseIdentifier.rawValue,
                    for: indexPath
                )
                
                cell.backgroundColor = .red
                print("Could not find appropriate section. Error red cell was loaded.")
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
}
