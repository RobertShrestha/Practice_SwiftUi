//
//  CheckoutView.swift
//  Cupcake Corner
//
//  Created by Robert Shrestha on 8/27/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI
// MARK: Section 5 : Checking for a valid address
struct CheckoutView: View {
    @ObservedObject var order: Order
    // MARK: Section 8
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    var body: some View {
        // MARK: Section 6: Preparing for checkout 
        GeometryReader { geo in
            ScrollView {
                VStack {
                    // MARK: Accessibility Challenge 1
                    Image(decorative: "cupcakes")
                    //Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)

                    Text("Your total is \(self.order.cost,specifier: "%.2f")")
                        .font(.title)
                    Button("Place order") {
                        self.placeOrder()
                    }.padding()
                }
            }
        }
        .navigationBarTitle("Check out", displayMode: .inline)
        .alert(isPresented: $showingConfirmation) {
            Alert(title: Text("Thank you!"), message: Text(confirmationMessage), dismissButton: .default(Text("Ok")))
        }
    }
    // MARK: Section 8 : Sending and receiving orders over the internet
    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Fail to encode order")
            return
        }
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encoded
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with:request) { data , response , error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                // MARK: Challange 2 : If our call to placeOrder() fails – for example if there is no internet connection – show an informative alert for the user. To test this, just disable WiFi on your Mac so the simulator has no connection either.
                self.confirmationMessage = error?.localizedDescription ??  "Unknown Error"
                self.showingConfirmation = true
                return
            }
            if let orderDecoded = try? JSONDecoder().decode(Order.self, from: data) {
                self.confirmationMessage = "Your order for \(orderDecoded.quantity)x \(Order.types[orderDecoded.type].lowercased()) cupcakes is on its way!"
                self.showingConfirmation = true
            } else {
                print("Invalid response from server")
            }
        }.resume()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
