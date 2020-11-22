//
//  Bundle+Decodable.swift
//  SnowSeeker
//
//  Created by Robert Shrestha on 11/22/20.
//

import Foundation
// MARK: - Section 4: Building a primary list of items
extension Bundle {
    func decode<T:Decodable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle")
        }
        return loaded
    }
}
