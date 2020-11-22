//
//  ContentView.swift
//  Accessibility
//
//  Created by Robert Shrestha on 9/28/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI

// MARK: Section 1: Identifying views with useful labels

struct IdentifiableLabel: View {
    let pictures = [
        "ales-krivec-15949",
        "galina-n-189483",
        "kevin-horstmann-141705",
        "nicolas-tissot-335096"
    ]
    let labels = [
        "Tulips",
        "Frozen tree buds",
        "Sunflowers",
        "Fireworks"
    ]
    @State private var selectedPicture = Int.random(in: 0...3)
    var body: some View {
        Image(pictures[selectedPicture])
            .resizable()
            .scaledToFit()
            .accessibility(label: Text(labels[selectedPicture]))
            .accessibility(addTraits: .isButton)
            .accessibility(removeTraits: .isImage)
            .onTapGesture {
                self.selectedPicture = Int.random(in: 0...3)
        }
    }
}

// MARK: Section 2: Hiding and grouping accessibility data
struct SectionTwoView: View {
    var body: some View {
//        Image(decorative: "plus")
//        .accessibility(hidden: true)
        VStack {
            Text("Your score is")
            Text("1000")
                .font(.title)
        }
       // .accessibilityElement(children: .combine)
        .accessibilityElement(children: .ignore)
        .accessibility(label: Text("Your score is 1000"))
    }
}

// MARK: Section 3: Reading the value of controls

struct SectionThreeView: View {
    @State private var estimate = 30.0

    @State private var rating = 3
    var body: some View {
        /*
        Slider(value: $estimate, in: 0...50)
        .padding()
        .accessibility(value: Text("\(Int(estimate))"))
        */
        Stepper("Rate our services: \(rating)/5",value: $rating, in: 1...5)
        .accessibility(value: Text("\(rating) out of 5"))
    }
}

struct ContentView: View {
    var body: some View {
       // Text("Hello, World!")

        // MARK: Section 1: Identifying views with useful labels
        //IdentifiableLabel()

        // MARK: Section 2: Hiding and grouping accessibility data
        //SectionTwoView()

        // MARK: Section 3: Reading the value of controls
        SectionThreeView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
