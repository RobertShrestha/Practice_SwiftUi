//
//  ContentView.swift
//  BetterRest
//
//  Created by Robert Shrestha on 8/2/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI
// MARK: Section 1
struct StepperView: View {
    @State private var sleepAmount = 8.0
    var body: some View {
        Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
            Text("\(sleepAmount, specifier: "%g") hours")
        }
    }
}
// MARK: Section 2
struct DatePickerView: View {
    @State private var wakeUp = Date()
    var body: some View {
        DatePicker("Please enter a date",
                   selection: $wakeUp,
                   displayedComponents: .hourAndMinute
                   //in: Date()...
        )
        .labelsHidden()
    }
}
// MARK: Section 3

struct DateView: View {
    @State private var wakeUp = Date() //change to defaultWakeTime in section 7
    var body: some View {
        // Create own date
            /*
            var components = DateComponents()
            components.hour = 8
            components.minute = 0
            let date = Calendar.current.date(from: components)
            */

   // Get date from component
            /*
            let components = Calendar.current.dateComponents([.hour,.minute], from: Date())
            let hour = components.hour ?? 0
            let minute = components.minute ?? 0
            */

     //Date Formatter
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            let dateString = formatter.string(from: Date())

            return DatePicker("Please enter a date",
                      selection: $wakeUp,
                      displayedComponents: .hourAndMinute
                //in: Date()...
            ).labelsHidden()
    }
}


struct ContentView: View {
    // Section 1:  Entering numbers with stepper
    //

    // Section 2:
    //

    // Section 5:

    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1

    // Section 6:
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false

    @State private var wakeUp = defaultWakeTime
    var body: some View {
        // MARK: Section 1 : Entering numbers with stepper
        //StepperView()

        // MARK: Section 2: Selecting dates and time with datePicker
        //DatePickerView()

        // MARK:  Section 3: Working with dates
        //DateView()


        // MARK: Section 4 : Training a model with Create ML

        // MARK: Section 5: Building a basic layout
        NavigationView{
            Form{ // VStack to form in section 7

                // MARK: Challange 1
                Section(header: Text("When do you want to wake up?")
                    .font(.headline)) {
                        DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle()) // section 7
                }
                Section(header:  Text("Desired amount of sleep")
                    .font(.headline)) {
                        Stepper(value: $sleepAmount, in: 4...12,step:  0.25) {
                            Text("\(sleepAmount,specifier: "%g") hours")
                        }

                        .accessibility(value:Text( getAccessibleSleepAmount()))
                }
                Section(header: Text("Daily coffee intake")
                    .font(.headline)) {
                        // MARK: Challenge 2
                        Picker( "Number of cups",selection: $coffeeAmount) {
                            //
                            ForEach(1...29,id: \.self){
                                Text("\($0)")
                            }
                        }

                }
                Section(header: Text("Your ideal time is")) {
                    Text("\(desireTime)")
                }
            }

                /*
                     VStack(alignment: .leading, spacing: 10) {
                     Text("When do you want to wake up?")
                     .font(.headline)
                     DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                     .labelsHidden()
                     .datePickerStyle(WheelDatePickerStyle()) // section 7
                     }
                     VStack(alignment: .leading, spacing: 10) {
                     Text("Desired amount of sleep")
                     .font(.headline)

                     Stepper(value: $sleepAmount, in: 4...12,step:  0.25) {
                     Text("\(sleepAmount,specifier: "%g") hours")
                     }
                     }
                     VStack(alignment: .leading, spacing: 10) {
                     Text("Daily coffee intake")
                     .font(.headline)

                     // Challange Task
                     Picker( "Number of cups",selection: $coffeeAmount) {
                     //
                     ForEach(1...29,id: \.self){
                     Text("\($0)")
                     }
                     }
                     //                    Stepper(value: $coffeeAmount, in: 1...20) {
                     //                        if coffeeAmount == 1 {
                     //                            Text("1 cup")
                     //                        } else {
                     //                            Text("\(coffeeAmount) cups")
                     //                        }
                     //                    }
                     }
                     }
                 */

            .navigationBarTitle("BetterRest")
            // MARK: Removed for challange 3
//            .navigationBarItems(trailing:
//                //                Button("Hello") {
//                //                    print("Button was tapped")
//                //                }
//                //                Button(action: {
//                //                    print("Button was tapped")
//                //                }, label: {
//                //                    Text("Helllo")
//                //                })
//
//                Button(action: calculateBedTime) {
//                    Text("Calculate")
//                }
//
//            )
            // MARK: Removed for challange 3
//                .alert(isPresented: $showingAlert) {
//                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
//                }
        }
    }

    // MARK: Accessibiltiy Challenge 2
    func getAccessibleSleepAmount() -> String {
        // round sleepAmount
        if floor(sleepAmount) == sleepAmount {
            return String(format: "%g", Double(sleepAmount)) + " hours"
        }
        // minutes
        let hours = Int(floor(sleepAmount))
        let minutesDecimal = sleepAmount - floor(sleepAmount)
        let minutes = Int(minutesDecimal * 60)
        return "\(hours) hours " + "\(minutes) minutes"
    }
    // MARK:  Section 7 : Cleaning up user inteface
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()

    }
    var desireTime: String {
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))

            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: sleepTime)
        } catch {
            return "Error"
        }
    }
    func calculateBedTime() {

        // MARK: Section 6 : Connecting SwiftUI to Core ML
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))

            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            alertMessage = formatter.string(from: sleepTime)
            alertTitle = "your ideal bed time is ..."
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating bed time"

        }
        showingAlert = true

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
