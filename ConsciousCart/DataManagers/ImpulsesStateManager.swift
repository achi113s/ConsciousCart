//
//  CoreDataMOCManager.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 6/26/23.
//

import CoreData
import UserNotifications

// should make thread safe?

final class ImpulsesStateManager {
    public let coreDataManager = CoreDataManager(modelName: "ConsciousCart")
    
    private(set) var userStats: UserStats? = nil
    private(set) var impulses: [Impulse] = [Impulse]()
    private(set) var completedImpulses: [Impulse] = [Impulse]()
    private(set) var pendingImpulses: [Impulse] = [Impulse]()
    
    lazy public var totalAmountSaved: Double = {
        return completedImpulses.reduce(0.0) { $0 + $1.amountSaved }
    }()
    
    public var userLevel: UserLevel {
        switch totalAmountSaved {
        case 5000...:
            return .ultimateSaver
        case 1000...:
            return .superSaver
        case 200...:
            return .saver
        default:
            return .beginner
        }
    }
    
    init() {
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
            let listOfUsers = try coreDataManager.mainManagedObjectContext.fetch(request)
            
            self.userStats = listOfUsers.first
        } catch {
            print("Error fetching UserStats from main context: \(error.localizedDescription)")
        }
    }
    
    public func addImpulse(remindDate: Date = Date(),
                           name: String = "Unknown Name",
                           price: Double = 0.0,
                           imageName: String? = nil,
                           reasonNeeded: String = "Unknown Reason") -> Impulse {
        
        let newImpulse = Impulse(context: coreDataManager.mainManagedObjectContext)
        newImpulse.id = UUID()
        newImpulse.userID = userStats?.id
        newImpulse.dateCreated = Date.now
        newImpulse.remindDate = remindDate
        newImpulse.name = name
        newImpulse.price = price
        newImpulse.imageName = imageName
        newImpulse.reasonNeeded = reasonNeeded
        newImpulse.completed = false
        
        coreDataManager.saveChanges()
        loadImpulses()
        
        return newImpulse
    }
    
    public func updateImpulse() {
        coreDataManager.saveChanges()
        loadImpulses()
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
                
                coreDataManager.mainManagedObjectContext.delete(impulse)
            }
            
            print("All impulses deleted!")
            
            coreDataManager.saveChanges()
            loadImpulses()
        } catch {
            print("Error deleting data from context: \(error.localizedDescription)")
        }
    }
    
    public func deleteImpulse(impulse: Impulse) {
        if let index = impulses.firstIndex(of: impulse) {
            impulses.remove(at: index)
            
            coreDataManager.deleteObject(object: impulse)
            
            loadImpulses()
        }
    }
    
    public func deleteUser(user: UserStats) {
        
    }
    
    public func setupNotification(for impulse: Impulse) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "ConsciousCart"
            content.body = "Your impulse for \(impulse.unwrappedName) is ready to be reviewed!"
            content.sound = .default
            content.categoryIdentifier = NotificationCategory.impulseExpired.rawValue
            
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents(in: .current, from: impulse.unwrappedRemindDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            //            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            
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
    
    public func updateNotification(for impulse: Impulse) {
        let center = UNUserNotificationCenter.current()
        
        center.removePendingNotificationRequests(withIdentifiers: [impulse.id.uuidString])
        
        setupNotification(for: impulse)
    }
    
    public func completeImpulseWithOption(_ option: ImpulseEndedOptions, for impulse: Impulse) {
        impulse.dateCompleted = Date.now
        impulse.completed = true
        
        switch option {
        case .waited:
            impulse.amountSaved = impulse.price
        case .waitedAndWillBuy:
            impulse.amountSaved = Double(0)
        case .failed:
            impulse.amountSaved = -impulse.price
        }
        
        updateImpulse()
    }
}
