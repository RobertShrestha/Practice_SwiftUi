//
//  DocumentDirectory-Decodable.swift
//  BucketList
//
//  Created by Robert Shrestha on 9/26/20.
//  Copyright © 2020 robert. All rights reserved.
//

import Foundation
extension FileManager {
    func decode<T: Codable>(_ file: String) -> T {
        let paths = self.urls(for: .documentDirectory, in: .userDomainMask)
        let documentPath = paths[0]
        let url = documentPath.appendingPathComponent(file)

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Fail to load \(file) from bundle.")
        }
        let decoder = JSONDecoder()
        guard let astronauts = try? decoder.decode(T.self, from: data) else {
            fatalError("Fail to decode \(file) from bundle")
        }
        return astronauts
    }
}
