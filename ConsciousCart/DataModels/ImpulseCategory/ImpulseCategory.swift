//
//  ImpulseCategory.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/25/23.
//

//import Foundation
//
//struct ImpulseCategory: Codable {
//    static let fileName = "CustomImpulseCategories.json"
//    
//    let categoryEmoji: String
//    let categoryName: String
//}
//
//class ImpulseCategories: NSObject {
//    // Default Categories
//    static let defaultCategories = [
//        ImpulseCategory(categoryEmoji: "📚", categoryName: "Books"),
//        ImpulseCategory(categoryEmoji: "👕", categoryName: "Clothing"),
//        ImpulseCategory(categoryEmoji: "💻", categoryName: "Electronics"),
//        ImpulseCategory(categoryEmoji: "🍿", categoryName: "Entertainment"),
//        ImpulseCategory(categoryEmoji: "🏡", categoryName: "Home"),
//        ImpulseCategory(categoryEmoji: "🍽️", categoryName: "Restaurants"),
//        ImpulseCategory(categoryEmoji: "👟", categoryName: "Shoes")
//    ]
//    
//    private var categories: [ImpulseCategory]
//    
//    override init() {
//        // Load custom categories. If file doesn't exist, load the default categories.
//        if let customCategories:[ImpulseCategory] = FileManager().decode(ImpulseCategory.fileName, encodingType: .utf8PlainText) {
//            self.categories = customCategories
//        } else {
//            self.categories = ImpulseCategories.defaultCategories
//        }
//    }
//    
//    func getCategories() -> [ImpulseCategory] {
//        return categories
//    }
//    
//    func addCustomCategory(emoji: String, name: String) {
//        let newCategory = ImpulseCategory(categoryEmoji: emoji, categoryName: name)
//        
//        self.categories.append(newCategory)
//        saveCustomCategories()
//    }
//    
//    func resetCategoriesToDefaults() {
//        
//    }
//    
//    private func saveCustomCategories() {
//        FileManager().encode(categories, fileName: ImpulseCategory.fileName, encodingType: .utf8PlainText)
//    }
//}
