//
//  Bundle-Decodable.swift
//  Moonshot
//
//  Created by Robert Shrestha on 8/11/20.
//  Copyright © 2020 robert. All rights reserved.
//

import Foundation

extension Bundle {

    /*
    func decode(_ file: String) -> [Astronaut] {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate the file")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Fail to load \(file) from bundle.")
        }
        let decoder = JSONDecoder()
        guard let astronauts = try? decoder.decode([Astronaut].self, from: data) else {
            fatalError("Fail to decode \(file) from bundle")
        }
        return astronauts
    }
    */

    // MARK: - Section 6: Using generic to load any kind of codable data
    func decode<T: Codable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate the file")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Fail to load \(file) from bundle.")
        }
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        guard let astronauts = try? decoder.decode(T.self, from: data) else {
            fatalError("Fail to decode \(file) from bundle")
        }
        return astronauts
    }
}
