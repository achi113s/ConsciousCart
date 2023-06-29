//
//  FileManager-DocumentsDirectory.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 5/14/23.
//

import UIKit
import UniformTypeIdentifiers

extension FileManager {
    static var documentsDirectory: URL {
        let paths = self.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths[0])
        return paths[0]
    }
    
    func decode<T: Decodable>(_ file: String, encodingType: UTType) -> T {
        guard let data = try? Data(contentsOf: FileManager.documentsDirectory.appendingPathComponent(file, conformingTo: encodingType)) else {
            fatalError("Failed to load \(file) from Documents.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from Documents.")
        }
        
        return loaded
    }
    
}

