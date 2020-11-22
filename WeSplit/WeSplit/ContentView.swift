//
//  ContentView.swift
//  WeSplit
//
//  Created by Robert Shrestha on 6/30/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI

// MARK: Section 1
struct BasicView: View {
    var body: some View {
        Text("Hello World")
    }
}
// MARK: Section 2
struct FormView: View {
    var body: some View {
        Form {
            Text("Hello, World!")
            Text("Hello, World!")
            Text("Hello, World!")
            Text("Hello, World!")
            Text("Hello, World!")
            Text("Hello, World!")
            Text("Hello, World!")
            Text("Hello, World!")
            Text("Hello, World!")
        }
    }
}
// MARK: Section 3
struct NavigationBarView: View {
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("Hello, World!")
                }
            }
            .navigationBarTitle(Text("SwiftUI"), displayMode: .inline)
        }
    }
}
// MARK: Section 4
struct ProgramStateView: View {
    @State private var tapCount = 0
    var body: some View {
        Button("Tap Count \(tapCount)") {
            self.tapCount += 1
        }
    }
}
// MARK: Section 5
struct BindStateView: View {
    @State private var name = ""
    var body: some View {
        Form {
            Section {
                TextField("Enter your name", text: $name)
                Text("Your name is \(name)")
            }
        }
    }
}
// MARK: Section 6
struct LoopView: View {
    var students = ["Ram", "Sita", "Hari"]
    @State private var selectedStudent = "Harry"
    var body: some View {
        /*
         Form {
         ForEach(0 ..< 100) {
         Text("\($0)")
         }
         }
         */
        Picker("Select your student", selection: $selectedStudent) {
            ForEach(0 ..< students.count) {
                Text("\(self.students[$0])")
            }
        }
    }
}

// MARK: Section 7
struct UserInterface: View {
    @State private var checkAmount = ""
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 2



    let tipPercentages = [10,15,20,25,0]
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipselection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0.0
        let tipValue = orderAmount/100 * tipselection
        let grandTotal = tipValue + orderAmount
        let amountPerPerson = grandTotal / peopleCount
        return amountPerPerson
    }
    var body: some View {
        NavigationView {
            Form{
                Section{
                    TextField("Amount", text: $checkAmount)
                        .keyboardType(.decimalPad)
                    Picker("Number of People", selection: $numberOfPeople) {
                        ForEach(2 ..< 100) {
                            Text("\($0) people")
                        }
                    }
                }
                Section(header:Text("How much tip do you want to leave")) {
                    Picker("How much tip do you want to leave", selection: $tipPercentage) {
                        ForEach(0 ..< tipPercentages.count) {
                            Text("\(self.tipPercentages[$0]) %")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section {
                    Text("$\(totalPerPerson, specifier: "%.2f")")
                        .foregroundColor(tipPercentages[tipPercentage] <= 0 ? .red : .black ) // challange from view and modifier


                }
            }
            .navigationBarTitle("WeSplit")
        }
    }
}
struct ContentView: View {


    var body: some View {

        // MARK: Section 1: Understanding the basic structure of a SwiftUI app
        //BasicView()

        // MARK: Section 2: Creating a form
        // FormView()

        // MARK:  Section 3: Adding a navigation bar
        //NavigationBarView()

        // MARK: Section 4: Modifying program state
        //ProgramStateView()

        // MARK: Section 5: Binding state to user interface controls
        //BindStateView()

        // MARK: Section 6: Creating views in a loop
        //LoopView()
        // MARK: Section 7: Reading text from the user with TextField
        UserInterface()

    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
