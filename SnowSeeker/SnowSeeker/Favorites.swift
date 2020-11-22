//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Robert Shrestha on 11/22/20.
//

import Foundation
// MARK: - Section 9: Letting the user mark favorites
class Favorites: ObservableObject {
    private var resorts: Set<String>

    private var saveKey = "Favorites"

    init() {
        // load our saved data

        // MARK: Challange 2: Fill in the loading and saving methods for Favorites.
        guard let data:Data = UserDefaults.standard.value(forKey: saveKey) as? Data  else {
            self.resorts = []
            return
        }
        if let decodedData = try? JSONDecoder().decode([String].self, from: data) {
            self.resorts = Set(decodedData.map { $0 })
        } else {
            self.resorts = []
        }
    }

    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }

    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }
    
    // MARK: Challange 2: Fill in the loading and saving methods for Favorites.
    func save() {
        if let encodedData = try? JSONEncoder().encode(resorts)  {
            UserDefaults.standard.setValue(encodedData, forKey: saveKey)
        }
    }
    /*
    func stringArrayToData(stringArray: [String]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: stringArray, options: [])
    }
    func dataToStringArray(data: Data) -> [String]? {
        return (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String]
    }
    */

}
