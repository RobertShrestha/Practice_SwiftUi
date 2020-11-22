//
//  Card.swift
//  FlashZilla
//
//  Created by Robert Shrestha on 11/16/20.
//

import Foundation
// MARK: Section 7: Designing a single card view
struct Card: Codable{
    let prompt: String
    let answer: String

    static var example: Card {
        Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
    }
}
