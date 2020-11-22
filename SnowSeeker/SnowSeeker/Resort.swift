//
//  Resort.swift
//  SnowSeeker
//
//  Created by Robert Shrestha on 11/22/20.
//

import Foundation
// MARK: - Section 4: Building a primary list of items
struct Resort: Codable, Identifiable {
    let id, name, country, resortDescription: String
    let imageCredit: String
    let price, size, snowDepth, elevation: Int
    let runs: Int
    let facilities: [String]

    // MARK: - Section 8: Binding an alert to an optional string
    var facilityTypes: [Facility] {
        facilities.map(Facility.init)
    }

    enum CodingKeys: String, CodingKey {
        case id, name, country
        case resortDescription = "description"
        case imageCredit, price, size, snowDepth, elevation, runs, facilities
    }
    static let allResorts: [Resort] = Bundle.main.decode("resorts.json")
    static let example = allResorts[0]
}
