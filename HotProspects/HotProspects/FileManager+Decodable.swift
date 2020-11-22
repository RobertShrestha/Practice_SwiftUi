//
//  FileManager+Decodable.swift
//  HotProspects
//
//  Created by Robert Shrestha on 10/24/20.
//  Copyright © 2020 robert. All rights reserved.
//

import Foundation


extension FileManager {
    func decode<T:Decodable>(fileName: String) throws -> T {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentPath = paths[0]
        let url = documentPath.appendingPathComponent(fileName)
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let objects = try decoder.decode(T.self, from: data)
        return objects
    }

    func encode<T:Encodable>(fileName: String, object: T)  throws{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentPath = paths[0]
        let url = documentPath.appendingPathComponent(fileName)
        let encoder = JSONEncoder()
        let data = try encoder.encode(object)
        try data.write(to: url, options: [.completeFileProtection,.atomicWrite])
        print("Saved")
    }
}
