//
//  FIlterView.swift
//  SnowSeeker
//
//  Created by Robert Shrestha on 11/22/20.
//

import SwiftUI

struct FilterView: View {
    var countries: [String] = ["All","France", "Austria", "United States", "Italy", "Canada",  ]
    var sizes: [String] = ["General","Small", "Medium", "Large","All"]
    var price: [String] = ["General","Cheap", "Expensive", "Lavish"]

    @Environment(\.presentationMode) var presentationMode
    @State private var chosenCountry: Int = 0
    @Binding var selectCountry: String
    @Binding var selectedSize: Int
    @Binding var selectedPrice: Int
//    @State private var selectedCountry = 0
//    @State private var selectedSize = 0
//    @State private var selectedPrice = 0
    var body: some View {
            Form {
                Picker("Select Country", selection: $chosenCountry) {
                    ForEach(0..<countries.count, id: \.self) {
                        Text(countries[$0])
                    }
                }
                //Text(selectCountry)
                Section(header: Text("Size of resort")) {
                    Picker("Size of resort", selection: $selectedSize) {
                        ForEach(0..<sizes.count, id: \.self) {
                            Text(sizes[$0])
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Price of resort")) {
                    Picker("Size of resort", selection: $selectedPrice) {
                        ForEach(0..<price.count, id: \.self) {
                            Text(price[$0])
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                Section() {
                    Button("Done") {
                        self.dismiss()
                    }
                }
                .onAppear(perform: bindView)
            }

    }
    func bindView() {
        self.selectCountry = self.countries[chosenCountry]
    }
    func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        //FilterView()
        FilterView(selectCountry: Binding.constant("All"), selectedSize: Binding.constant(1), selectedPrice: Binding.constant(1))
    }
}
