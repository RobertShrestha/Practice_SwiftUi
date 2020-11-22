//
//  C3AddressView.swift
//  Cupcake Corner
//
//  Created by Robert Shrestha on 8/27/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI

struct C3AddressView: View {
     @ObservedObject var order: MyOrder
    var body: some View {

        Form {
            Section {
                TextField("Name", text: $order.orderStruct.name)
                TextField("Street Address", text: $order.orderStruct.streetAddress)
                TextField("City",text: $order.orderStruct.city)
                TextField("Zip", text:$order.orderStruct.zip)
            }
            Section {
                NavigationLink(destination: C3CheckoutView(order: order)) {
                    Text("Checkout")
                }.disabled(order.orderStruct.hasValidAddress == false)
            }
        }
        .navigationBarTitle("Delivery Details",displayMode: .inline)
    }
}

struct C3AddressView_Previews: PreviewProvider {
    static var previews: some View {
        C3AddressView(order: MyOrder())
    }
}
