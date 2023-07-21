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

    // MARK: - Core Data stack

    // This is an SQLite Database
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ConsciousCart")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext  // scratchpad, temporary area where you can update change data before you're satisfied
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func displayImpulseScreenFromNotification(for response: UNNotificationResponse) {
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
            
            mainCVNavController.present(impulseExpiredVC, animated: false)
        } else {
            print("Error: Could not present a new view controller.")
        }
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}

