//
//  Order.swift
//  Cupcake Corner
//
//  Created by Robert Shrestha on 8/27/20.
//  Copyright © 2020 robert. All rights reserved.
//

import Foundation


// MARK: Challange 3: For a more challenging task, see if you can convert our data model from a class to a struct, then create an ObservableObject class wrapper around it that gets passed around. This will result in your class having one @Published property, which is the data struct inside it, and should make supporting Codable on the struct much easier.

class MyOrder: ObservableObject {
    @Published var orderStruct = OrderStruct()
}

// MARK: Section 4: Taking basic order details


class OrderStruct: Codable{
    enum CodingKeys: CodingKey {
        case type, quantity, extraFrosting, addSprinkles, streetAddress, city, name, zip
    }
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
     var type = 0
     var quantity = 3
     var specialRequestEnabled = false {
        didSet {
            if self.specialRequestEnabled {
                self.addSprinkles = false
                self.extraFrosting = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false

    var streetAddress = ""
    var city = ""
    var name = ""
    var zip = ""

    var hasValidAddress: Bool {
        // MARK: Challange 1: Our address fields are currently considered valid if they contain anything, even if it’s just only whitespace. Improve the validation to make sure a string of pure whitespace is invalid.
        if self.streetAddress.trimmingCharacters(in: .whitespaces).isEmpty || self.city.trimmingCharacters(in: .whitespaces).isEmpty || self.name.trimmingCharacters(in: .whitespaces).isEmpty || self.zip.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        return true
    }
    // MARK: Section 6: Preparing for checkout
    var cost: Double {
        var cost = Double(quantity) * 2
        cost += Double(type)/2
        if extraFrosting {
            cost += Double(quantity)
        }
        if addSprinkles {
            cost += Double(quantity)/2
        }
        return cost
    }
    // MARK: Section 7: Encoding an ObservableObject class
    init() { }
    /*
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)
        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
        name = try container.decode(String.self, forKey: .name)
        streetAddress = try container.decode(String.self, forKey: .streetAddress)
        city = try container.decode(String.self, forKey: .city)
        zip = try container.decode(String.self, forKey: .zip)


    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(addSprinkles, forKey: .addSprinkles)
        try container.encode(name, forKey: .name)
        try container.encode(streetAddress, forKey: .streetAddress)
        try container.encode(city, forKey: .city)
        try container.encode(zip, forKey: .zip)
    }
    */

}




class Order: ObservableObject, Codable{
    enum CodingKeys: CodingKey {
        case type, quantity, extraFrosting, addSprinkles, streetAddress, city, name, zip
    }
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    @Published var type = 0
    @Published var quantity = 3
    @Published var specialRequestEnabled = false {
        didSet {
            if self.specialRequestEnabled {
                self.addSprinkles = false
                self.extraFrosting = false
            }
        }
    }
    @Published var extraFrosting = false
    @Published var addSprinkles = false

    @Published var streetAddress = ""
    @Published var city = ""
    @Published var name = ""
    @Published var zip = ""

    var hasValidAddress: Bool {
        // MARK: Challange 1: Our address fields are currently considered valid if they contain anything, even if it’s just only whitespace. Improve the validation to make sure a string of pure whitespace is invalid.
        if self.streetAddress.trimmingCharacters(in: .whitespaces).isEmpty || self.city.trimmingCharacters(in: .whitespaces).isEmpty || self.name.trimmingCharacters(in: .whitespaces).isEmpty || self.zip.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        return true
    }
    // MARK: Section 6: Preparing for checkout
    var cost: Double {
        var cost = Double(quantity) * 2
        cost += Double(type)/2
        if extraFrosting {
            cost += Double(quantity)
        }
        if addSprinkles {
            cost += Double(quantity)/2
        }
        return cost
    }
     // MARK: Section 7: Encoding an ObservableObject class
    init() { }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)
        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
        name = try container.decode(String.self, forKey: .name)
        streetAddress = try container.decode(String.self, forKey: .streetAddress)
        city = try container.decode(String.self, forKey: .city)
        zip = try container.decode(String.self, forKey: .zip)


    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(addSprinkles, forKey: .addSprinkles)
        try container.encode(name, forKey: .name)
        try container.encode(streetAddress, forKey: .streetAddress)
        try container.encode(city, forKey: .city)
        try container.encode(zip, forKey: .zip)
    }

}
