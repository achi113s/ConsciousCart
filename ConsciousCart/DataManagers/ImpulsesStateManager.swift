//
//  CoreDataMOCManager.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 6/26/23.
//

import CoreData
import UserNotifications

final class ImpulsesStateManager {
    public let coreDataManager = CoreDataManager(modelName: "ConsciousCart")
    
    private(set) var userStats: UserStats? = nil
    private(set) var impulses: [Impulse] = [Impulse]()
    private(set) var completedImpulses: [Impulse] = [Impulse]()
    private(set) var pendingImpulses: [Impulse] = [Impulse]()
    
    private(set) var impulseCategories: [ImpulseCategory] = [ImpulseCategory]()
    
    init() {
        loadCategories()
        loadImpulses()
        loadUserStats()
    }
    
    private func loadImpulses(with request: NSFetchRequest<Impulse> = Impulse.fetchRequest()) {
        do {
            request.sortDescriptors = [NSSortDescriptor(key:"dateCreated", ascending:true)]
            let allImpulses = try coreDataManager.mainManagedObjectContext.fetch(request)
            
            self.impulses = allImpulses.filter { !$0.completed && ($0.unwrappedRemindDate > Date.now)}
            self.pendingImpulses = allImpulses.filter { !$0.completed && ($0.unwrappedRemindDate < Date.now)}
            self.completedImpulses = allImpulses.filter { $0.completed }.sorted(by: { $0.unwrappedCompletedDate < $1.unwrappedCompletedDate })
        } catch {
            print("Error fetching Impulses from main context: \(error.localizedDescription)")
        }
    }
    
    private func loadUserStats(with request: NSFetchRequest<UserStats> = UserStats.fetchRequest()) {
        do {
            var listOfUsers = try coreDataManager.mainManagedObjectContext.fetch(request)
            
            if let user = listOfUsers.first {
                self.userStats = user
                print("user info placed into user var")
            } else {
                print("No user was found so we are creating one.")
                createUserStats()
                
                // reload
                listOfUsers = try coreDataManager.mainManagedObjectContext.fetch(request)
                
                if let user = listOfUsers.first {
                    self.userStats = user
                }
            }
        } catch {
            print("Error fetching UserStats from main context: \(error.localizedDescription)")
        }
    }
    
    private func loadCategories(with request: NSFetchRequest<ImpulseCategory> = ImpulseCategory.fetchRequest()) {
        do {
            self.impulseCategories = try coreDataManager.mainManagedObjectContext.fetch(request)
            
            if self.impulseCategories.isEmpty {
                createDefaultCategories()
                
                self.impulseCategories = try coreDataManager.mainManagedObjectContext.fetch(request)
            }
        } catch {
            print("Error fetching Categories from main context: \(error.localizedDescription)")
        }
    }
}

//MARK: - Impulses CRUD
extension ImpulsesStateManager {
    public func saveImpulses() {
        coreDataManager.saveChanges()
        loadImpulses()
    }
    
    // Creating
    public func addImpulse(remindDate: Date = Date(),
                           name: String = "Unknown Name",
                           price: Double = 0.0,
                           imageName: String? = nil,
                           reasonNeeded: String = "Unknown Reason",
                           url: String = "None",
                           category: String = "") -> Impulse {
        
        let newImpulse = Impulse(context: coreDataManager.mainManagedObjectContext)
        newImpulse.id = UUID()
        newImpulse.userID = userStats?.id
        newImpulse.dateCreated = Date.now
        newImpulse.remindDate = remindDate
        newImpulse.name = name
        newImpulse.price = price
        newImpulse.imageName = imageName
        newImpulse.reasonNeeded = reasonNeeded
        newImpulse.url = url
        newImpulse.category = category
        newImpulse.completed = false

        return newImpulse
    }
    
    // Updating
    public func completeImpulseWithOption(_ option: ImpulseEndedOptions, for impulse: Impulse) {
        impulse.dateCompleted = Date.now
        impulse.completed = true
        
        switch option {
        case .waited:
            impulse.amountSaved = impulse.price
        case .waitedAndWillBuy:
            impulse.amountSaved = Double(0)
            // The user doesn't save any money here, so we don't need to update userStats.
        case .failed:
            impulse.amountSaved = -impulse.price
        }
    }
    
    // Deleting
    public func deleteImpulse(impulse: Impulse) {
        if let index = impulses.firstIndex(of: impulse) {
            impulses.remove(at: index)
        
            coreDataManager.deleteObject(object: impulse)
        }
    }
    
    public func deletePendingImpulse(impulse: Impulse) {
        if let index = pendingImpulses.firstIndex(of: impulse) {
            pendingImpulses.remove(at: index)
            
            coreDataManager.deleteObject(object: impulse)
        }
    }
    
    public func deleteCompletedImpulse(impulse: Impulse) {
        if let index = completedImpulses.firstIndex(of: impulse) {
            completedImpulses.remove(at: index)
            
            coreDataManager.deleteObject(object: impulse)
        }
    }
    
    public func deleteAllImpulses() {
        do {
            let allImpulses = try coreDataManager.mainManagedObjectContext.fetch(Impulse.fetchRequest())
            
            for impulse in allImpulses {
                // Delete the image in the Documents directory if it exists.
                if let imageName = impulse.imageName {
                    let imagePathName = FileManager.documentsDirectory.appendingPathComponent(imageName, conformingTo: .png)
                    do {
                        try FileManager.default.removeItem(at: imagePathName)
                    } catch {
                        print("Could not delete Impulse's image: \(error.localizedDescription)")
                    }
                }
                
                // Remove the notifications for the Impulse.
                removePendingNotification(for: impulse)
                
                coreDataManager.deleteObject(object: impulse)
            }
            
            print("All impulses deleted!")
        } catch {
            print("Error deleting data from context: \(error.localizedDescription)")
        }
    }
}

//MARK: - Notifications Handlers
extension ImpulsesStateManager {
    public func setupNotification(for impulse: Impulse) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "ConsciousCart"
            content.body = "Your impulse for \(impulse.unwrappedName) is ready to be reviewed!"
            content.sound = .default
            content.categoryIdentifier = NotificationCategory.impulseExpired.rawValue
            
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.year, .day, .month, .hour, .minute, .second], from: impulse.unwrappedRemindDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            
            let request = UNNotificationRequest(identifier: impulse.id.uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        if let error = error {
                            print("Error authorizing notifications: \(error.localizedDescription)")
                        } else {
                            print("Unknown error authorizing notifications.")
                        }
                    }
                }
            }
        }
    }
    
    public func removePendingNotification(for impulse: Impulse) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [impulse.id.uuidString])
    }
}

//MARK: - User Stats CRUD
extension ImpulsesStateManager {
    public func saveUserStats() {
        coreDataManager.saveChanges()
        loadUserStats()
    }
    
    // Creating
    private func createUserStats() {
        let newUser = UserStats(context: coreDataManager.mainManagedObjectContext)
        newUser.id = UUID()
        newUser.level = Int16(UserLevel.beginner.rawValue)
        newUser.totalAmountSaved = 0.0
        newUser.dateCreated = Date.now
    }
    
    // Updating
    public func updateUserAmountSaved(amount: Double) {
        guard let userStats = userStats else { return }
        
        let runningTotalSaved = userStats.totalAmountSaved + amount
        
        userStats.totalAmountSaved = runningTotalSaved
        
        switch runningTotalSaved {
        case 5000...:
            userStats.level = Int16(UserLevel.ultimateSaver.rawValue)
        case 1000...:
            userStats.level = Int16(UserLevel.superSaver.rawValue)
        case 200...:
            userStats.level = Int16(UserLevel.saver.rawValue)
        default:
            userStats.level = Int16(UserLevel.beginner.rawValue)
        }
    }

    public func updateUserName(to newName: String) {
        guard let userStats = userStats else {
            fatalError("The userStats object could not be unwrapped.")
        }
        
        userStats.userName = newName
    }

    // Deleting
    public func deleteUser() {
        guard let userStats = userStats else { return }
        coreDataManager.deleteObject(object: userStats)
    }
    
    public func getUserLevel() -> UserLevel {
        guard let userStats = userStats else { return .beginner }
        
        switch userStats.level {
        case 0:
            return UserLevel.beginner
        case 1:
            return UserLevel.saver
        case 2:
            return UserLevel.superSaver
        case 3:
            return UserLevel.ultimateSaver
        default:
            return UserLevel.beginner
        }
    }
}

//MARK: - Categories CRUD
extension ImpulsesStateManager {
    private func createDefaultCategories() {
        let defaultCategories = [
            ("📚", "Books"),
            ("👕", "Clothing"),
            ("💻", "Electronics"),
            ("🍿", "Entertainment"),
            ("🏡", "Home"),
            ("🍽️", "Restaurants"),
            ("👟", "Shoes")
        ]
        
        for category in defaultCategories {
            let newCategory = ImpulseCategory(context: coreDataManager.mainManagedObjectContext)
            newCategory.categoryEmoji = category.0
            newCategory.categoryName = category.1
        }
    }
    
    public func saveImpulseCategory() {
        coreDataManager.saveChanges()
        loadCategories()
    }
    
    public func addNewCategory(categoryEmoji: String, categoryName: String) {
        let newCategory = ImpulseCategory(context: coreDataManager.mainManagedObjectContext)
        newCategory.categoryEmoji = categoryEmoji
        newCategory.categoryName = categoryName
    }
    
    public func deleteImpulseCategory(_ category: ImpulseCategory) {
        if let index = impulseCategories.firstIndex(of: category) {
            impulseCategories.remove(at: index)
            
            coreDataManager.deleteObject(object: category)
        }
    }
    
    public func saveCategories() {
        coreDataManager.saveChanges()
        loadCategories()
    }
    
    public func deleteAllCategories() {
        do {
            let allCategories = try coreDataManager.mainManagedObjectContext.fetch(ImpulseCategory.fetchRequest())
            
            for category in allCategories {
                coreDataManager.deleteObject(object: category)
            }
            
            print("All categories deleted!")
        } catch {
            print("Error deleting data from context: \(error.localizedDescription)")
        }
    }
}
