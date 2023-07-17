//
//  BarcodeAPIManager.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 5/3/23.
//

import Foundation

// This manager is using the old async API with completion handlers.
// It can (should) be updated to use the new async-await API.

protocol BarcodeAPIManagerDelegate {
    func didFetchBarcodeInfo(_ barcodeAPIManager: BarcodeAPIManager, barcodeInfo: BarcodeInfo)
    func didFailWithError(error: Error)
}

struct BarcodeAPIManager {
    let barcodeAPIURL = "https://api.barcodespider.com/v1/lookup?token=\(Secrets.barcodeSpiderAPIKey)"
    
    var delegate: BarcodeAPIManagerDelegate?
    
    func fetchBarcodeInfo(for barcode: String) {
        let urlString = "\(barcodeAPIURL)&upc=\(barcode)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let barcodeInfo = self.parseJSON(safeData) {
                        delegate?.didFetchBarcodeInfo(self, barcodeInfo: barcodeInfo)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ barcodeData: Data) -> BarcodeInfo? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let decodedData = try decoder.decode(BarcodeInfo.self, from: barcodeData)
            
            let barcodeInfo = decodedData
            return barcodeInfo
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
