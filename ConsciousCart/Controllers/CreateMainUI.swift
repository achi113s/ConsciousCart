//
//  CreateMainUI.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/9/23.
//

import UIKit

class CreateMainUI {
    var impulsesStateManager: ImpulsesStateManager! = nil
    
    private func createMainCVC() -> UINavigationController {
        let mainCVC = MainCollectionViewController()
        mainCVC.title = "ConsciousCart"
        mainCVC.impulsesStateManager = impulsesStateManager
        
        mainCVC.tabBarItem = UITabBarItem()
        mainCVC.tabBarItem.image = UIImage(systemName: "cart.circle")
        mainCVC.tabBarItem.title = "My Cart"
        mainCVC.tabBarItem.tag = TabBarKeys.mainTab.rawValue
        
        return UINavigationController(rootViewController: mainCVC)
    }
    
    private func createProfileVC() -> UINavigationController {
        let profileVC = ProfileViewController(impulsesStateManager: impulsesStateManager)
        profileVC.title = "Profile"
        
        profileVC.tabBarItem = UITabBarItem()
        profileVC.tabBarItem.image = UIImage(systemName: "person.circle")
        profileVC.tabBarItem.title = "Profile"
        profileVC.tabBarItem.tag = TabBarKeys.profileTab.rawValue
        if impulsesStateManager.pendingImpulses.count > 0 {
            profileVC.tabBarItem.badgeValue = "\(impulsesStateManager.pendingImpulses.count)"
        }
        
        return UINavigationController(rootViewController: profileVC)
    }
    
    private func createSettingsVC() -> UIViewController {
        let settingsVC = SettingsViewController(impulsesStateManager: impulsesStateManager)
        settingsVC.title = "Settings"
        
        settingsVC.tabBarItem = UITabBarItem()
        settingsVC.tabBarItem.image = UIImage(systemName: "gearshape")
        settingsVC.tabBarItem.title = "Settings"
        settingsVC.tabBarItem.tag = TabBarKeys.settingsTab.rawValue
        
        return settingsVC
    }
    
    public func createUI() -> UITabBarController {
        let tabBar = UITabBarController()
        UITabBar.appearance().tintColor = .black
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundColor = .systemGray5
        tabBar.viewControllers = [createMainCVC(), createProfileVC(), createSettingsVC()]
        
        return tabBar
    }
}
