//
//  Prospect.swift
//  HotProspects
//
//  Created by Robert Shrestha on 10/3/20.
//  Copyright © 2020 robert. All rights reserved.
//

import Foundation

// MARK: Section 10: Sharing data across tabs using @EnvironmentObject
class Prospect: Identifiable, Codable {
    var id = UUID()
    var createDate = Date()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
}

class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    static let saveKey = "SavedData"

    init() {
        people = []
       // people = load()

        // MARK: Challange 2: Use JSON and the documents directory for saving and loading our user data.
        people = self.loadFromDoc()
        // MARK: Section 15: Saving and loading data with UserDefaults
        /*
        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                self.people = decoded
                return
            }
        }
        self.people = []
        */

    }

    private func load() -> [Prospect] {
        if let data = UserDefaults.standard.data(forKey: Prospects.saveKey) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                self.people = decoded
                return decoded
            }
        }
       return []

    }

     // MARK: Section 15: Saving and loading data with UserDefaults
    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }

    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    // MARK: Section 14: Adding options with a context menu
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
    }
    // MARK: Challange 2: Use JSON and the documents directory for saving and loading our user data.
    func addInDoc(_ prospect: Prospect) {
        people.append(prospect)
        saveInDoc()
    }
    private func loadFromDoc() -> [Prospect] {
        do {
            let datas = try FileManager.default.decode(fileName: Self.saveKey) as [Prospect]
            self.people = datas
            return datas
        }catch let error {
            print(error.localizedDescription)
            return []
        }
    }

    private func saveInDoc() {
        do {
            try FileManager.default.encode(fileName:  Self.saveKey, object: people)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
