//
//  Astronaut.swift
//  Moonshot
//
//  Created by Robert Shrestha on 8/11/20.
//  Copyright © 2020 robert. All rights reserved.
//

import Foundation

struct Astronaut: Codable, Identifiable {
    var id: String
    var name: String
    var description: String
    var accessibleName: String {
        name.replacingOccurrences(of: ".", with: " ")
    }
}
