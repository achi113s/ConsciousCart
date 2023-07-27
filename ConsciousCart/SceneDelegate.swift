//
//  SceneDelegate.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 4/21/23.
//

import UIKit
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let impulsesStateManager = ImpulsesStateManager(moc: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let titleTextAttributes = [NSAttributedString.Key.font: UIFont.ccFont(textStyle: .bold, fontSize: 17)]
        let largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.ccFont(textStyle: .largeTitle)]

        UINavigationBar.appearance().titleTextAttributes = titleTextAttributes
        UINavigationBar.appearance().largeTitleTextAttributes = largeTitleTextAttributes
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = createTabBar()
        window?.overrideUserInterfaceStyle = .light
//        UserDefaults.standard.bool(forKey: UserDefaultsKeys.forceDarkModeSetting.rawValue) ? .dark : .unspecified
        window?.makeKeyAndVisible()
    }
    
    func createMainCVC() -> UINavigationController {
        let mainCVC = MainCollectionViewController()
        mainCVC.title = "ConsciousCart"
        mainCVC.impulsesStateManager = impulsesStateManager
        
        mainCVC.tabBarItem = UITabBarItem()
        mainCVC.tabBarItem.image = UIImage(systemName: "cart.circle")
        mainCVC.tabBarItem.title = "My Cart"
        mainCVC.tabBarItem.tag = TabBarKeys.mainTab.rawValue
        
        return UINavigationController(rootViewController: mainCVC)
    }
    
    func createProfileVC() -> UIViewController {
        let profileVC = ProfileViewController()
        profileVC.title = "My Profile"
        profileVC.impulsesStateManager = impulsesStateManager
        
//        let profileFontSize: CGFloat = 32
//        let sizeConfig = UIImage.SymbolConfiguration(pointSize: profileFontSize, weight: .regular, scale: .default)
        profileVC.tabBarItem = UITabBarItem()
        profileVC.tabBarItem.image = UIImage(systemName: "person.circle")
//        , withConfiguration: sizeConfig)!.withBaselineOffset(fromBottom: profileFontSize / 1.8)
//        profileVC.tabBarItem.image = UIImage(named: "person.circle")
        profileVC.tabBarItem.title = "Profile"
        profileVC.tabBarItem.tag = TabBarKeys.profileTab.rawValue
        if impulsesStateManager.completedImpulses.count != 0 {
            profileVC.tabBarItem.badgeValue = "\(impulsesStateManager.pendingImpulses.count)"
        }
//        return UINavigationController(rootViewController: profileVC)
        return profileVC
    }
    
    func createSettingsVC() -> UIViewController {
        let settingsVC = SettingsViewController()
        settingsVC.title = "Settings"
        settingsVC.impulsesStateManager = impulsesStateManager
        
        settingsVC.tabBarItem = UITabBarItem()
        settingsVC.tabBarItem.image = UIImage(systemName: "gearshape")
        settingsVC.tabBarItem.title = "Settings"
        settingsVC.tabBarItem.tag = TabBarKeys.settingsTab.rawValue
        
        return settingsVC
    }
    
    func createTabBar() -> UITabBarController {
        let tabBar = UITabBarController()
        UITabBar.appearance().tintColor = .black
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundColor = .systemGray5
        tabBar.viewControllers = [createMainCVC(), createProfileVC(), createSettingsVC()]
        
        return tabBar
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}
