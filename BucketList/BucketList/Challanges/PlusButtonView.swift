//
//  PlusButtonView.swift
//  BucketList
//
//  Created by Robert Shrestha on 9/27/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI
import MapKit

struct PlusButtonView: View {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var locations: [CodableMKPointAnnotation]
    @Binding var selectedPlace: MKPointAnnotation?
    @Binding var showingEditScreen: Bool
    var body: some View {
        Button(action: {
            let newlocation = CodableMKPointAnnotation()
            newlocation.title = "Example Location"
            newlocation.coordinate = self.centerCoordinate
            self.locations.append(newlocation)

            // MARK: Section 9: Extending existing types to support ObservableObject
            self.selectedPlace = newlocation
            self.showingEditScreen = true
        }) {
            Image(systemName: "plus")
                // MARK: Challenge 1
                .padding()
                .background(Color.black.opacity(0.75))
                .foregroundColor(.white)
                .font(.title)
                .clipShape(Circle())
                .padding(.trailing)
        }
    }
}
