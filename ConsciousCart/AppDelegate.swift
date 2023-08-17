//
//  AppDelegate.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 4/21/23.
//

import CoreData
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        
        registerUserDefaultsDefaults()
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let notificationCategory = response.notification.request.content.categoryIdentifier
        
        switch notificationCategory {
        case NotificationCategory.impulseExpired.rawValue:
            displayImpulseScreenFromNotification(for: response)
        default:
            print("No defined notification category response.")
        }
        
        completionHandler()
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    private func displayImpulseScreenFromNotification(for response: UNNotificationResponse) {
        guard let sceneDelegate = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate) else {
            print("Error: Could not get Scene Delegate.")
            return
        }
        guard let window = sceneDelegate.window else {
            print("Error: Could not get window from Scene Delegate.")
            return
        }
        guard let tabBarController = window.rootViewController as? UITabBarController else {
            print("Error: Could not get UITabBarController from window.")
            return
        }
        
        let impulseID = response.notification.request.identifier
        
        guard let impulse = sceneDelegate.impulsesStateManager.impulses.first(where: { $0.id.uuidString == impulseID }) else {
            print("Error: Could not find Impulse.")
            return
        }
        
        tabBarController.selectedIndex = TabBarKeys.mainTab.rawValue
        if let mainCVNavController = tabBarController.selectedViewController as? UINavigationController {
            let impulseExpiredVC = ImpulseExpiredViewController()
            impulseExpiredVC.impulse = impulse
            impulseExpiredVC.impulsesStateManager = sceneDelegate.impulsesStateManager
            // this type of modal presentation forces the presentingViewController to call
            // viewWillAppear when the new one is dismissed.
            impulseExpiredVC.modalPresentationStyle = .fullScreen
            
            let modalController = UINavigationController(rootViewController: impulseExpiredVC)
            
            mainCVNavController.present(modalController, animated: true)
        } else {
            print("Error: Could not present a new view controller.")
        }
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    private func registerUserDefaultsDefaults() {
        UserDefaults.standard.register(defaults: [
            UserDefaultsKeys.allowHaptics.rawValue: true,
            UserDefaultsKeys.accentColor.rawValue: "ShyMoment"
        ])
    }
}

