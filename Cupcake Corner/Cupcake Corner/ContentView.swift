//
//  ContentView.swift
//  Cupcake Corner
//
//  Created by Robert Shrestha on 8/27/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI

// MARK: Section 1: Adding Codable conformance for @Published properties
class User: ObservableObject, Codable {
    @Published var name = "Ram Sita"
    enum CodingKeys: CodingKey {
        case name
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name,forKey: .name)
    }


}

// MARK: Section 2: Sending and receiving Codable data with URLSession and SwiftUI

struct Response: Codable {
    var results: [Result]
}
struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String

}
struct SectionTwoView: View {
    @State var results = [Result]()
    var body: some View {
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
            }
        }
    .onAppear(perform: loadData)
    }
    func loadData() {
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invalid URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let data = data {
                if let decodeResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    DispatchQueue.main.async {
                        self.results = decodeResponse.results
                    }
                    return
                }
            }
            print("Something went wrong \(error?.localizedDescription ?? "Unknown error")")
        }.resume()

    }
}
// MARK: Section 3: Validating and disabling form

struct FormView: View {
    @State private var userName = ""
    @State private var email = ""
    var disableAction: Bool {
        self.userName.count < 5 || self.email.count < 5
    }
    var body: some View{
        Form {
            Section {
                TextField("Enter username", text: $userName)
                TextField("Enter Email", text: $email)
            }
            Section {
                Button("Create Account") {
                    print("Creating account")
                }.disabled(disableAction)
            }
        }

    }
}

// MARK: Section 4: Taking basic order details

struct OrderDetailView: View {
    @ObservedObject var order = Order()
    var body: some View{
        NavigationView {
            Form {
                Section {
                    Picker ("Select your cake type", selection: $order.type) {
                        ForEach(0..<Order.types.count,id: \.self) {
                            Text(Order.types[$0])
                        }
                    }
                    Stepper(value: $order.quantity,in: 3...20) {
                        Text("Number of cakes: \(order.quantity)")
                    }
                }
                Section {
                    Toggle(isOn: self.$order.specialRequestEnabled.animation()) {
                        Text("Any special requests?")
                    }
                    if order.specialRequestEnabled {
                        Toggle(isOn: $order.extraFrosting) {
                            Text("Add more forsting")
                        }
                        Toggle(isOn:$order.addSprinkles) {
                            Text("Add Sprinklers")
                        }
                    }
                }
                Section {
                    NavigationLink(destination: AddressView(order: order)) {
                        Text("Delivery Details")
                    }
                }
            }
        .navigationBarTitle("Cupcake Corner")
        }
    }
}

struct ContentView: View {
    var body: some View {
        //Text("Hello World")
        // MARK: Section 2
        //SectionTwoView()

        // MARK: Section 3
        //FormView()

        // MARK: Section 4
        OrderDetailView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
