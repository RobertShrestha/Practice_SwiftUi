//
//  C3ContentView.swift
//  Cupcake Corner
//
//  Created by Robert Shrestha on 8/27/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI

struct C3ContentView: View {
     @ObservedObject var order = MyOrder()
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker ("Select your cake type", selection: $order.orderStruct.type) {
                        ForEach(0..<Order.types.count,id: \.self) {
                            Text(Order.types[$0])
                        }
                    }
                    Stepper(value: $order.orderStruct.quantity,in: 3...20) {
                        Text("Number of cakes: \(order.orderStruct.quantity)")
                    }
                }
                Section {
                    Toggle(isOn: self.$order.orderStruct.specialRequestEnabled.animation()) {
                        Text("Any special requests?")
                    }
                    if order.orderStruct.specialRequestEnabled {
                        Toggle(isOn: $order.orderStruct.extraFrosting) {
                            Text("Add more forsting")
                        }
                        Toggle(isOn:$order.orderStruct.addSprinkles) {
                            Text("Add Sprinklers")
                        }
                    }
                }
                Section {
                    NavigationLink(destination: C3AddressView(order: order)) {
                        Text("Delivery Details")
                    }
                }
            }
            .navigationBarTitle("Cupcake Corner")
        }
    }
}

struct C3ContentView_Previews: PreviewProvider {
    static var previews: some View {
        C3ContentView()
    }
}
