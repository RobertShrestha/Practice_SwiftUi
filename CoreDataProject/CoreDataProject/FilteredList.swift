//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Robert Shrestha on 9/7/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI
import CoreData
struct FilteredList<T: NSManagedObject, content: View>: View {
    var fetchRequest: FetchRequest<T>
    var singers: FetchedResults<T> {
        fetchRequest.wrappedValue
    }
    let content: (T) -> content
    var body: some View {
        List(fetchRequest.wrappedValue, id: \.self) { singer in
            self.content(singer)
        }
    }
    // MARK: Challanage 1: Make it accept an array of NSSortDescriptor objects to get used in its fetch request.
    init(filterKey: String, filterValue: String, sortDescriptors: [NSSortDescriptor],predicateFormat: PredicateEnum, @ViewBuilder  content: @escaping (T) -> content) {
        fetchRequest = FetchRequest<T>(entity: Singer.entity(), sortDescriptors: sortDescriptors, predicate: NSPredicate(format: predicateFormat.rawValue, filterKey, filterValue))
        self.content = content
    }
}
 // MARK: Challange 3:Modify the predicate string parameter to be an enum such as .beginsWith, then make that enum get resolved to a string inside the initializer.
enum PredicateEnum: String {
    case beginWith = "%K BEGINSWITH %@"
}
