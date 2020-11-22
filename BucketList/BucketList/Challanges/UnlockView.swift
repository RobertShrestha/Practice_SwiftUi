//
//  UnlockView.swift
//  BucketList
//
//  Created by Robert Shrestha on 9/27/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI
import MapKit
import LocalAuthentication
struct UnlockView: View {
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var locations = [CodableMKPointAnnotation]()
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingPlaceDetail = false
    @State private var showingEditScreen = false
    var body: some View {
        ZStack {
            AdvancedMapView(centerCoordinate: $centerCoordinate,
                            selectedPlace: $selectedPlace,
                            showingPlaceDetail: $showingPlaceDetail,
                            annotations: locations)
                .edgesIgnoringSafeArea(.all)

            CircleView()
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    PlusButtonView(centerCoordinate: $centerCoordinate,
                                   locations: $locations,
                                   selectedPlace: $selectedPlace,
                                   showingEditScreen: $showingEditScreen)
                }
            }
                // MARK: Section 8: Customizing MKMapView annotations
                .alert(isPresented: $showingPlaceDetail) {
                    Alert(title: Text(selectedPlace?.title ?? "Unknown"),
                          message: Text(selectedPlace?.subtitle ?? "Missing Place Information. "),
                          primaryButton: .default(Text("Ok")),
                          secondaryButton: .default(Text("Edit")){
                            self.showingEditScreen = true
                        })
            }
                // MARK: Section 9: Extending existing types to support ObservableObject
                .sheet(isPresented: $showingEditScreen, onDismiss: saveData) {
                    if self.selectedPlace != nil {
                        EditView(placemark: self.selectedPlace!)
                    }
            }
        }
    .onAppear(perform: loadData)
    }
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func loadData() {
        let filename = getDocumentDirectory().appendingPathComponent("SavedPlaces")

        do {
            let data = try Data(contentsOf: filename)
            locations = try JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
        } catch {
            print("Unable to load saved data.")
        }
    }
    func saveData() {
        do {
            let filename = getDocumentDirectory().appendingPathComponent("SavedPlaces")
            let data = try JSONEncoder().encode(self.locations)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
}

struct UnlockView_Previews: PreviewProvider {
    static var previews: some View {
        UnlockView()
    }
}
