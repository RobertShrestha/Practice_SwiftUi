//
//  AddressView.swift
//  Cupcake Corner
//
//  Created by Robert Shrestha on 8/27/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI
// MARK: Section 4: Taking basic order details
struct AddressView: View {
    @ObservedObject var order: Order
    var body: some View {
        // MARK: Section 5 : Checking for a valid address
        Form {
            Section {
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City",text: $order.city)
                TextField("Zip", text:$order.zip)
            }
            Section {
                NavigationLink(destination: CheckoutView(order: order)) {
                    Text("Checkout")
                }.disabled(order.hasValidAddress == false)
            }
        }
        .navigationBarTitle("Delivery Details",displayMode: .inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
    }
}
