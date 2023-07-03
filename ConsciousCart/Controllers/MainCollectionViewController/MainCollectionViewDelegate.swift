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
        guard let impulsesStateManager = impulsesStateManager else { return }
        guard indexPath.section == 1 else { return }
        guard !impulsesStateManager.impulses.isEmpty else { return }
        
        let detailVC = ImpulseDetailViewController()
        detailVC.impulse = impulsesStateManager.impulses[indexPath.row]
        
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
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        guard let impulsesStateManager = impulsesStateManager else { return false }
        guard !impulsesStateManager.impulses.isEmpty else { return false }
        return true
    }
}
