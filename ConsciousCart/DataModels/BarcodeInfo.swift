//
//  BarcodeModel.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 5/3/23.
//

import Foundation

struct BarcodeInfo: Codable {
    var itemResponse: ItemResponse
    var itemAttributes: ItemAttributes
    var Stores: [Store]
}

struct ItemResponse: Codable {
    var code: Int
}

struct ItemAttributes: Codable {
    var title: String
    var upc: String
    var manufacturer: String
    var image: String
}

struct Store: Codable {
    var storeName: String
    var price: String
    var currency: String
}
