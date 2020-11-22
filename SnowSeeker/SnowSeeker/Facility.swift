//
//  Facility.swift
//  SnowSeeker
//
//  Created by Robert Shrestha on 11/22/20.
//

import SwiftUI
// MARK: - Section 8: Binding an alert to an optional string
/*
struct Facility {
    static func icon(for facility: String) -> some View {
        let icons = [
            "Accommodation": "house",
            "Beginners": "1.circle",
            "Cross-country": "map",
            "Eco-friendly": "leaf.arrow.circlepath",
            "Family": "person.3"
        ]
        if let iconName = icons[facility] {
            let image = Image(systemName: iconName)
                .accessibility(label: Text(facility))
                .foregroundColor(.secondary)
            return image
        } else {
            fatalError("Unknown facility type: \(facility)")
        }
    }
    static func alert(for facility: String) -> Alert {
        let messages = [
            "Accommodation": "This resort has popular on-site accomodation.",
            "Beginners": "This resort has lots of ski schools.",
            "Cross-country": "This resort has many cross-country ski routes.",
            "Eco-friendly": "This resort has won an award for environment friendless",
            "Family": "This resort is popular with families"
        ]
        if let message = messages[facility] {
            return Alert(title: Text(facility), message: Text(message))
        } else {
            fatalError("Unknown facility type: \(facility)")
        }
    }
}
*/

// Second Method
struct Facility: Identifiable {
    let id = UUID()
    var name: String

    var icon: some View {
        let icons = [
            "Accommodation": "house",
            "Beginners": "1.circle",
            "Cross-country": "map",
            "Eco-friendly": "leaf.arrow.circlepath",
            "Family": "person.3"
        ]
        if let iconName = icons[name] {
            let image = Image(systemName: iconName)
                .accessibility(label: Text(name))
                .foregroundColor(.secondary)
            return image
        } else {
            fatalError("Unknown facility type: \(name)")
        }
    }
    var alert: Alert {
        let messages = [
            "Accommodation": "This resort has popular on-site accomodation.",
            "Beginners": "This resort has lots of ski schools.",
            "Cross-country": "This resort has many cross-country ski routes.",
            "Eco-friendly": "This resort has won an award for environment friendless",
            "Family": "This resort is popular with families"
        ]
        if let message = messages[name] {
            return Alert(title: Text(name), message: Text(message))
        } else {
            fatalError("Unknown facility type: \(name)")
        }
    }
}
