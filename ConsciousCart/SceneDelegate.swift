//
//  SceneDelegate.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 4/21/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = createTabBar()
//        window?.overrideUserInterfaceStyle = .light
        window?.makeKeyAndVisible()
    }
    
    func createMainVC() -> UINavigationController {
        let mainVC = MainViewController()
        mainVC.title = "ConsciousCart"
    
//        let cartFontSize: CGFloat = 32
//        let sizeConfig = UIImage.SymbolConfiguration(pointSize: cartFontSize, weight: .regular, scale: .default)
        
        mainVC.tabBarItem = UITabBarItem()
        mainVC.tabBarItem.image = UIImage(systemName: "cart.circle")
//        , withConfiguration: sizeConfig)!.withBaselineOffset(fromBottom: cartFontSize / 1.3)
        mainVC.tabBarItem.title = "My Cart"
        
        return UINavigationController(rootViewController: mainVC)
    }
    
    func createProfileVC() -> UINavigationController {
        let profileVC = ProfileViewController()
        profileVC.title = "My Profile"
        
//        let profileFontSize: CGFloat = 32
//        let sizeConfig = UIImage.SymbolConfiguration(pointSize: profileFontSize, weight: .regular, scale: .default)
        
        profileVC.tabBarItem = UITabBarItem()
        profileVC.tabBarItem.image = UIImage(systemName: "person.circle")
//        , withConfiguration: sizeConfig)!.withBaselineOffset(fromBottom: profileFontSize / 1.8)
//        profileVC.tabBarItem.image = UIImage(named: "person.circle")
        profileVC.tabBarItem.title = "Profile"
        
        return UINavigationController(rootViewController: profileVC)
    }
    
    func createSettingsVC() -> UINavigationController {
        //MARK: - temporarily put ProfileViewController here
        let settingsVC = ProfileViewController()
        settingsVC.title = "Settings"
    
//        let cartFontSize: CGFloat = 32
//        let sizeConfig = UIImage.SymbolConfiguration(pointSize: cartFontSize, weight: .regular, scale: .default)
        
        settingsVC.tabBarItem = UITabBarItem()
        settingsVC.tabBarItem.image = UIImage(systemName: "gearshape")
//        , withConfiguration: sizeConfig)!.withBaselineOffset(fromBottom: cartFontSize / 1.3)
        settingsVC.tabBarItem.title = "Settings"
        
        return UINavigationController(rootViewController: settingsVC)
    }
    
    func createTabBar() -> UITabBarController {
        let tabBar = UITabBarController()
        UITabBar.appearance().tintColor = .black
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundColor = .systemGray5
        tabBar.viewControllers = [createMainVC(), createProfileVC(), createSettingsVC()]
        
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
