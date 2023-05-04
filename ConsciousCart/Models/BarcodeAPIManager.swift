//
//  BarcodeAPIManager.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 5/3/23.
//

import Foundation

protocol BarcodeAPIManagerDelegate {
    func didUpdateWeather(_ barcodeAPIManager: BarcodeAPIManager, barcode: BarcodeModel)
    func didFailWithError(error: Error)
}

struct BarcodeAPIManager {
    let barcodeAPIURL = "https://api.barcodespider.com/v1/lookup?token=e5fdd46b53d2ea5e3377&upc="
}
