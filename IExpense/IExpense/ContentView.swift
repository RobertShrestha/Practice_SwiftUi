//
//  ContentView.swift
//  IExpense
//
//  Created by Robert Shrestha on 8/6/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI

// MARK: Section 1

 /*
 class User {
     var firstNmae = "Bilbo"
     var lastName = "Baggins"
 }
 */

struct UserInputView: View {
    @ObservedObject private var user = User()
    var body: some View {
        VStack {
            Text("Your name is \(user.firstNmae) \(user.lastName)")
            TextField("First Name", text: $user.firstNmae)
            TextField("Last name", text:  $user.lastName)
        }
    }
}

// MARK: Section 2
class User: ObservableObject {
    @Published var firstNmae = "Bilbo"
    @Published var lastName = "Baggins"
}
// MARK: Section 3

struct SecondView: View {
    @Environment(\.presentationMode) var presentationMode
    var name: String
    var body: some View {
        VStack {
            Text("Hello \(name)")
            Button("Dimiss") {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

// MARK: - Challange 2
struct AmountText: ViewModifier {
    var amount: Int
    func body(content: Content) -> some View {
        if amount < 10 {
            return content.foregroundColor(.green)
        } else if amount >= 10 && amount < 100{
            return content.foregroundColor(.orange)
        } else {
            return content.foregroundColor(.red)
        }
    }
}

extension View {
    func amountText(with amount: Int) -> some View {
        return self.modifier(AmountText(amount: amount))
    }
}

struct HideShowView: View {
    @State private var showingSheet = false
    var body: some View {
         Button("Show sheet") {
            self.showingSheet.toggle()
         }
         .sheet(isPresented: $showingSheet) {
            SecondView(name: "Robert")
         }
    }
}

// MARK: Section 4
struct ListOnDeleteView: View {
    @State private var numbers = [Int]()
    @State private var newNumber = 1
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(numbers, id: \.self) {
                        Text("\($0)")
                    }
                    .onDelete(perform: deleteRow(at:))
                }
                Button("Add Number") {
                    self.numbers.append(self.newNumber)
                    self.newNumber += 1
                }
            }
            .navigationBarItems(leading: EditButton())
        }
    }
    func deleteRow(at offsets: IndexSet) {
        self.numbers.remove(atOffsets: offsets)
    }
}
// MARK: Section 5
struct UserDefaultsView: View {
    @State private var tapCount = UserDefaults.standard.integer(forKey: "Tap")
    var body: some View {
        Button("Tap count \(tapCount)") {
            self.tapCount += 1
            UserDefaults.standard.set(self.tapCount, forKey: "Tap")
        }
    }
}

// MARK:  Section 6
struct UserCodable: Codable {
    var firstName: String
    var lastName: String
}
struct CodableView: View {
    @State private var user = UserCodable(firstName: "Robert", lastName: "Shrestha")
    var body: some View {
        Button("Save") {
            let encoder = JSONEncoder()

            if let data = try? encoder.encode(self.user) {
                UserDefaults.standard.set(data, forKey: "user_data")
            }
        }
    }
}


// MARK: Section 7
// Section 0 Identificable added plus id added
struct ExpenseItem: Identifiable,Codable {
    var id = UUID()
    var name: String
    var type: String
    var amount: Int
}

class Expenses: ObservableObject {
    @Published  var items = [ExpenseItem]() {

        // MARK: Section 10: Making changes permanent with UserDefaults
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(self.items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                self.items.append(contentsOf: decoded)
                return
            }
        }
        self.items = []
    }
}
struct ListDeletableView: View {
    @ObservedObject private var expenses = Expenses()
    @Environment(\.presentationMode) var presentation
    @State private var showingAddView = false
    var body: some View {
        NavigationView {
            List {
                //ForEach(expenses.items,id: \.name) { item in // can remove id paramter because the struct is identifiable

                // MARK: Section 8: Working with identifiable item in swiftUI
                ForEach(expenses.items) { item in
                    // Text(item.name)
                    // MARK: Section 11: Final Polish
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text("$\(item.amount)")
                            .amountText(with: item.amount)

                    }

                }.onDelete(perform: deleteRow(at:))
            }
            .navigationBarTitle("iExpense")
                // MARK: Challange 1
                .navigationBarItems(leading: EditButton(), trailing:
                    Button(action: {
                        //                    let expense = Expense(name: "Robert", type: "Normal", amount: 5)
                        //                    self.expenses.items.append(expense)
                        //Section 9
                        self.showingAddView = true
                    }) {
                        Image(systemName: "plus")
                    }
            )
                // MARK: Section 9: Sharing an observed object into a new view
                .sheet(isPresented: $showingAddView) {
                    AddView(expenses: self.expenses)
            }
        }

    }
    func deleteRow(at offsets: IndexSet) {
        self.expenses.items.remove(atOffsets: offsets)
    }
}


struct ContentView: View {
    var body: some View {
        // MARK:  Section 1:  why @State only works with struct.
        // Struct is value type so a new object is created everytime value changes and @State can catch it and update the view but classes have reference type so @State will not catch the change so it wll not update the view
       //UserInputView()

        // MARK:  Section 3 : Showing and hiding view
        //HideShowView()

        // MARK:  Section 4: Deleting item using onDelete()
        //ListOnDeleteView()

        // MARK: Section 5: Storing user setting in userdefaults
        //UserDefaultsView()

        // MARK: Section 6: Archiving swift objects with Codable
        //CodableView()

        // MARK: Section 7: Building a list we can delete from
         ListDeletableView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
