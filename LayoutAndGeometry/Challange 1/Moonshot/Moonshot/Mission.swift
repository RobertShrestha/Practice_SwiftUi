//
//  Mission.swift
//  Moonshot
//
//  Created by Robert Shrestha on 8/11/20.
//  Copyright © 2020 robert. All rights reserved.
//

import Foundation

// MARK: - Section 6: Using generic to load any kind of codable data
struct Mission: Codable, Identifiable {
    let id: Int
    let launchDate: Date?
    let crew: [CrewRole]
    let description: String

    struct CrewRole:Codable {
        let name: String
        let role: String
    }

    // MARK: - Section 7: Formatting our mission view
    var displayName: String {
        "Apollo \(id)"
    }

    var imageName: String {
        "apollo\(id)"
    }
    var formattedLunchDate: String {
        if let launchDate = launchDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: launchDate)
        } else {
            return "N/A"
        }
    }
    var accessibleLaunchDate: String {
        formattedLunchDate.replacingOccurrences(of: "Date: N/A", with: "Date is not applicable")
    }

    func crewNames(astronauts: [Astronaut], separator: Character = "\n") -> String {
        var crewNames = ""

        for member in crew {
            if let match = astronauts.first(where: { $0.id == member.name }) {
                crewNames += match.name + String(separator)
            }
            else {
                fatalError("Crew member \(member.name) not found")
            }
        }

        return String(crewNames.dropLast())
    }

   // MARK: Accessibility View
    func accessibleCrewNames(astronauts: [Astronaut], separator: Character = "\n") -> String {
        crewNames(astronauts: astronauts).replacingOccurrences(of: ".", with: " ")
    }
}
