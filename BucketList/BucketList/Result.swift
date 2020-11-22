//
//  Result.swift
//  BucketList
//
//  Created by Robert Shrestha on 9/26/20.
//  Copyright © 2020 robert. All rights reserved.
//

import Foundation
// MARK: Section 10: Downloading data from Wikipedia
struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}
struct Page: Codable, Comparable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?

    // MARK: Section 11: Sorting Wikipedia results 

    var description: String {
        terms?["description"]?.first ?? "No Further information"
    }

    static func < (lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
}
