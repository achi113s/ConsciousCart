////
////  ImpulseCollectionViewDataSource.swift
////  ConsciousCart
////
////  Created by Giorgio Latour on 7/29/23.
////
//
//import UIKit
//
//extension ImpulseCollectionView {
//    class ImpulseCollectionViewDataSource: NSObject, UICollectionViewDataSource {
//        var impulsesStateManager: ImpulsesStateManager? = nil
//        var impulseOption: ImpulseOption? = nil
//        
//        init(impulsesStateManager: ImpulsesStateManager? = nil, impulseOption: ImpulseOption? = .active) {
//            self.impulsesStateManager = impulsesStateManager
//            self.impulseOption = impulseOption
//        }
//        
//        func numberOfSections(in collectionView: UICollectionView) -> Int {
//            return 1
//        }
//        
//        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//            switch impulseOption {
//            case .active:
//                return impulsesStateManager?.impulses.count ?? 0
//            case .pending:
//                return impulsesStateManager?.pendingImpulses.count ?? 0
//            case .completed:
//                return impulsesStateManager?.completedImpulses.count ?? 0
//            default:
//                return 0
//            }
//        }
//        
//        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//            guard let impulsesStateManager = impulsesStateManager else {
//                let cell = collectionView.dequeueReusableCell(
//                    withReuseIdentifier: MainCollectionViewReuseIdentifiers.defaultCellReuseIdentifier.rawValue,
//                    for: indexPath
//                )
//                
//                cell.backgroundColor = .red
//                print("Could not unwrap impulsesStateManager. Error red cell was loaded.")
//                return cell
//            }
//            
//            // Section 0 is the Savings Chart Section
//            if indexPath.section == CVSection.chartSection.rawValue {
//                let cell = collectionView.dequeueReusableCell(
//                    withReuseIdentifier: MainCollectionViewReuseIdentifiers.savingsChartCellReuseIdentifier.rawValue,
//                    for: indexPath
//                )
//                
//                cell.contentConfiguration = UIHostingConfiguration {
//                    SavingsChart(completedImpulses: impulsesStateManager.completedImpulses)
//                }
//                
//                return cell
//            } else if indexPath.section == CVSection.impulseSection.rawValue {
//                // Show the Impulses.
//                let cell = collectionView.dequeueReusableCell(
//                    withReuseIdentifier: MainCollectionViewReuseIdentifiers.impulseCellReuseIdentifier.rawValue,
//                    for: indexPath
//                ) as! ImpulseCollectionViewListCell
//                
//                let index: Int = indexPath.row
//                
//                let impulse: Impulse = impulsesStateManager.impulses[index]
//                
//                var content = UIListContentConfiguration.subtitleCell()
//                let itemPrice = impulse.price.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD"))
//                content.text = "\(impulse.unwrappedName), \(itemPrice)"
//                content.textProperties.font = UIFont.ccFont(textStyle: .title3)
//                
//                let remainingTime = Utils.remainingTimeMessageForDate(impulse.unwrappedRemindDate)
//                content.secondaryText = remainingTime.0
//                
//                cell.contentConfiguration = content
//                
//                cell.accessories = [.disclosureIndicator()]
//                
//                return cell
//            } else {
//                let cell = collectionView.dequeueReusableCell(
//                    withReuseIdentifier: MainCollectionViewReuseIdentifiers.defaultCellReuseIdentifier.rawValue,
//                    for: indexPath
//                )
//                
//                cell.backgroundColor = .red
//                print("Could not find appropriate section. Error red cell was loaded.")
//                return cell
//            }
//        }
//        
//        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//            if kind == MainCollectionViewReuseIdentifiers.impulsesCategoryHeaderIdentifier.rawValue {
//                let header = collectionView.dequeueReusableSupplementaryView(
//                    ofKind: kind,
//                    withReuseIdentifier: MainCollectionViewReuseIdentifiers.headerIdentifier.rawValue,
//                    for: indexPath
//                )
//                
//                return header
//            } else {
//                let footer = collectionView.dequeueReusableSupplementaryView(
//                    ofKind: kind,
//                    withReuseIdentifier: MainCollectionViewReuseIdentifiers.footerIdentifier.rawValue,
//                    for: indexPath
//                )
//                
//                return footer
//            }
//        }
//    }
//}
