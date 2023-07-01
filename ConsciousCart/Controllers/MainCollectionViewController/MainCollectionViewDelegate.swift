//
//  MainCollectionViewDelegate.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 6/30/23.
//

import UIKit

//MARK: - UICollectionViewDelegate
class MainCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    var impulsesStateManager: ImpulsesStateManager?
    var mainCVC: MainCollectionViewController?
    
    init(impulsesStateManager: ImpulsesStateManager? = nil, mainCVC: MainCollectionViewController? = nil) {
        self.impulsesStateManager = impulsesStateManager
        self.mainCVC = mainCVC
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        
        let detailVC = ImpulseDetailViewController()
        detailVC.impulse = impulsesStateManager?.impulses[indexPath.row]
        
        mainCVC?.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImpulseCollectionViewCell else { return }
        
        UIView.animate(withDuration: 0.5) {
            cell.contentView.backgroundColor = .lightGray
        }
        
        UIView.animate(withDuration: 0.5) {
            cell.contentView.backgroundColor = .systemBackground
        }
    }
    
    
}
