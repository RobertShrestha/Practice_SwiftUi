//
//  ContentView.swift
//  BucketList
//
//  Created by Robert Shrestha on 9/11/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI
import LocalAuthentication
import MapKit

// MARK: Section 1: Adding conformance to Comparable for custom types

struct User: Identifiable, Comparable {
    let id = UUID()
    let firstName: String
    let lastName: String

    static func < (lhs: User, rhs: User) -> Bool {
        lhs.lastName < rhs.lastName
    }
}

struct ComparableView: View {
    let users = [
        User(firstName: "Ram", lastName: "Subedi"),
        User(firstName: "Hari", lastName: "Shrestha"),
        User(firstName: "Shyam", lastName: "Tuladhar")
    ]
    var body: some View {
        List(users) { user in
            Text("\(user.firstName) \(user.lastName)")

        }
    }
}
// MARK: Section 2: Writing data to the documents directory
struct DocumentDirectoryView: View {
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    var body: some View {
        Text("Hello world")
            .onTapGesture {
                let str = "Test Message"
                let url = self.getDocumentDirectory().appendingPathComponent("message.txt")
                do {
                    try str.write(to: url, atomically: true, encoding: .utf8)
                    let input = try String(contentsOf: url)
                    print(input)
                } catch {
                    print(error.localizedDescription)
                }
        }
    }
}
// MARK: Section 3: Switching view states with enums
struct LoadingView: View {
    var body: some View {
        Text("Loading...")
    }
}
struct SuccessView: View {
    var body: some View {
        Text("Success!")
    }
}
struct FailedView: View {
    var body: some View {
        Text("Failed.")
    }
}

struct SwitchingViewEnumView: View {
    enum LoadingState {
        case loading, success, failed
    }
    var loadingState = LoadingState.success
    var body: some View {
        Group {
            if loadingState == .loading {
                LoadingView()
            } else if loadingState == .success {
                SuccessView()
            } else if loadingState == .failed {
                FailedView()
            }
        }
    }
}

// MARK: Section 6: Using Touch ID and Face ID with SwiftUI
struct AuthenticationView: View {
    @State private var isUnlocked = false
    var body: some View {
        VStack {
            if self.isUnlocked {
                Text("Unlocked")
            } else {
                Text("Locked")
            }
        }.onAppear(perform: authenticate)
    }

    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, authenticationError) in
                if success {
                    self.isUnlocked = true
                } else {

                }
            }
        } else {

        }
    }
}

// MARK: Section 7: Advanced MKMapView with SwiftUI
struct NewMapView: View {
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var locations = [CodableMKPointAnnotation]()
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingPlaceDetail = false
    @State private var showingEditScreen = false
    @State private var isUnlocked = false

    var body: some View {
        ZStack {
            if isUnlocked {
            AdvancedMapView(centerCoordinate: $centerCoordinate,
                            selectedPlace: $selectedPlace,
                            showingPlaceDetail: $showingPlaceDetail,
                            annotations: locations)
                .edgesIgnoringSafeArea(.all)
            Circle()
                .fill(Color.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)

            VStack {
                Spacer()
                HStack {
                    Spacer()
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
                         // MARK: Challenge 1: 
                    /*
                    .padding()
                    .background(Color.black.opacity(0.75))
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding(.trailing)
                    */
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
            } else {
                Button("Unlock Places") {
                    self.authenticate()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        }
        .onAppear(perform: loadData)
    }
    // MARK: Section 12: Making someone else’s class conform to Codable
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
    func authenticate() {
        let context = LAContext() 
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, authenticationError) in
                if success {
                    self.isUnlocked = true
                } else {

                }
            }
        } else {
            // no biometric
        }
    }
}

struct ContentView: View {
    var body: some View {
       // Text("Hello, World!")

        // MARK: Section 1: Adding conformance to Comparable for custom types
        //ComparableView()

        // MARK: Section 2: Writing data to the documents directory
        //DocumentDirectoryView()

        // MARK: Section 3: Switching view states with enums
       // SwitchingViewEnumView()

        // MARK: Section 4: Integrating MapKit with SwiftUI
//        MapView()
//            .edgesIgnoringSafeArea(.all)

        // MARK: Section 6: Using Touch ID and Face ID with SwiftUI
        //AuthenticationView()

        // MARK: Section 7: Advanced MKMapView with SwiftUI
        //NewMapView()

        // MARK: Challange 2: Having a complex if condition in the middle of ContentView isn’t easy to read – can you rewrite it so that the MapView, Circle, and Button are part of their own view? This might take more work than you think!
        BucketListView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
