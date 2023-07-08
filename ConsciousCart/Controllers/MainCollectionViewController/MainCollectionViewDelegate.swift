//
//  MainCollectionViewDelegate.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 6/30/23.
//

import UIKit

//MARK: - UICollectionViewDelegate
class MainCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    var impulsesStateManager: ImpulsesStateManager? = nil
    var mainCVC: MainCollectionViewController? = nil
    
    init(impulsesStateManager: ImpulsesStateManager?, mainCVC: MainCollectionViewController?) {
        self.impulsesStateManager = impulsesStateManager
        self.mainCVC = mainCVC
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == CVSection.impulseSection.rawValue else { return }
        guard let impulsesStateManager = impulsesStateManager else { return }
        guard let mainCVC = mainCVC else { return }
        
        let detailVC = ImpulseDetailViewController()
        detailVC.impulse = impulsesStateManager.impulses[indexPath.row]
        
        mainCVC.navigationController?.pushViewController(detailVC, animated: true)
    }
}
