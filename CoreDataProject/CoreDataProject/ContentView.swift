//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Robert Shrestha on 9/7/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI
 // MARK: Section 1: Why does \.self work for ForEach?
struct Student: Hashable {
    let name: String
}
struct SelfView: View {
    let students = [Student(name: "Ram") , Student(name: "Hari")]
    var body: some View {
        List(students, id: \.self) { student in
            Text(student.name)
        }
    }
}
// MARK: Section 3: Conditional saving of NSManagedObjectContext
struct ConditionalSaveView: View {
    @Environment(\.managedObjectContext) var moc
    var body: some View {
        Button("Save") {
            if self.moc.hasChanges {
                try? self.moc.save()
            }
        }
    }
}
// MARK: Section 4: Ensuring Core Data objects are unique using constraints

struct CoreDataConstraints: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Wizard.entity(), sortDescriptors: []) var wizards: FetchedResults<Wizard>
    var body: some View{
        VStack {
            List(wizards, id: \.self) { wizard in
                Text(wizard.name ?? "Unknown wizard")
            }
            Button("Add") {
                let wizard = Wizard(context: self.moc)
                wizard.name = "Hari Ram"
            }
            Button("Save") {
                do {
                    try self.moc.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
// MARK: Section 5: Filtering @FetchRequest using NSPredicate
struct FetchRequestNSPredicate: View {
    @Environment(\.managedObjectContext) var moc
    //static let predicate = NSPredicate(format: "universe == 'Star Wars'")
//    static let predicate = NSPredicate(format: "universe == %@", "Star Wars")
//    static let predicate = NSPredicate(format: "name < %@", "F")

   /*
    /// gives value if any value of array
   static let predicate = NSPredicate(format: "universe in %@", ["Aliens", "Firefly", "Star Trek"])
   */
//    static let predicate = NSPredicate(format: "name BEGINWITH %@", "E")

    /*
    /// Ignore case sensitive
    static let predicate = NSPredicate(format: "name BEGINSWITH[c] %@", "E")
     */

    /// Reverse result
     static let predicate = NSPredicate(format: "NOT name BEGINSWITH[c] %@", "E")
    @FetchRequest(entity: Ship.entity(), sortDescriptors: [], predicate: predicate) var ships: FetchedResults<Ship>
    var body: some View {
        VStack {
            List(ships, id: \.self) { ship in
                Text(ship.name ?? "Unknown name")
            }
            Button("Add Examples") {
                let ship1 = Ship(context: self.moc)
                ship1.name = "Enterprise"
                ship1.universe = "Star Trek"

                let ship2 = Ship(context: self.moc)
                ship2.name = "Defaint"
                ship2.universe = "Star Trek"

                let ship3 = Ship(context: self.moc)
                ship3.name = "Millennium Falcon"
                ship3.universe = "Star Wars"

                let ship4 = Ship(context: self.moc)
                ship4.name = "Executor"
                ship4.universe = "Star Wars"

                try? self.moc.save()
            }
        }
    }
}

// MARK: Section 6: Dynamically filtering @FetchRequest with SwiftUI
struct DynamicallyFilteringView: View {
    @Environment(\.managedObjectContext) var moc
    @State var lastNameFilter = "A"
    var body: some View {
        VStack {
            // MARK: Challange 2: Make it accept a string parameter that controls which predicate is applied. You can use Swift’s string interpolation to place this in the predicate.

            // MARK: Challange 3:Modify the predicate string parameter to be an enum such as .beginsWith, then make that enum get resolved to a string inside the initializer.

            FilteredList(filterKey: "lastName",
                         filterValue: lastNameFilter,
                         sortDescriptors: [],
                         predicateFormat: .beginWith) { (singer: Singer) in
                                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
                        }
            Button("Add Example") {
                let taylor = Singer(context: self.moc)
                taylor.firstName = "Taylor"
                taylor.lastName = "Swift"

                let ed = Singer(context: self.moc)
                ed.firstName = "Ed"
                ed.lastName = "Sheeran"

                let adele = Singer(context: self.moc)
                adele.firstName = "Adele"
                adele.lastName = "Adkins"

                try? self.moc.save()
            }
            Button("Show A") {
                self.lastNameFilter = "A"
            }
            Button("Show S") {
                self.lastNameFilter = "S"
            }
        }
    }
}

// MARK: Section 7: One-to-many relationships with @FetchRequest and SwiftUI
// Candy and Country core data object created
// country and candy have one to many relationship because a country can produce different type of candy
// Unwrapped the optional values

struct OneToManyView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Country.entity(), sortDescriptors: []) var countries: FetchedResults<Country>
    var body: some View {
        VStack {
            List {
                ForEach(countries, id: \.self) { country in
                    Section(header: Text(country.wrappedFullName)) {
                        ForEach(country.candyArray, id: \.self) { candy in
                            Text(candy.wrappedName)
                        }
                    }
                }
            }
            Button("Add") {
                let candy1 = Candy(context: self.moc)
                candy1.name = "Mars"
                candy1.origin = Country(context: self.moc)
                candy1.origin?.shortName = "UK"
                candy1.origin?.fullName = "United Kingdom"

                let candy2 = Candy(context: self.moc)
                candy2.name = "KitKat"
                candy2.origin = Country(context: self.moc)
                candy2.origin?.shortName = "UK"
                candy2.origin?.fullName = "United Kingdom"

                let candy3 = Candy(context: self.moc)
                candy3.name = "TWix"
                candy3.origin = Country(context: self.moc)
                candy3.origin?.shortName = "UK"
                candy3.origin?.fullName = "United Kingdom"

                let candy4 = Candy(context: self.moc)
                candy4.name = "Toblerone"
                candy4.origin = Country(context: self.moc)
                candy4.origin?.shortName = "CH"
                candy4.origin?.fullName = "Switzerland"

                try? self.moc.save()
            }
        }
    }
}

struct ContentView: View {

    var body: some View {
        // MARK: Section 1: Why does \.self work for ForEach?
        // Beacause it just creates a hashvale of the item
        //SelfView()

        // MARK: Section 3: Conditional saving of NSManagedObjectContext
        //ConditionalSaveView()

        // MARK: Section 4: Ensuring Core Data objects are unique using constraints
        //CoreDataConstraints()

        // MARK: Section 5: Filtering @FetchRequest using NSPredicate
        //FetchRequestNSPredicate()

        // MARK: Section 6: Dynamically filtering @FetchRequest with SwiftUI
        DynamicallyFilteringView()
        // MARK: Section 7: One-to-many relationships with @FetchRequest and SwiftUI\]
        //OneToManyView()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
