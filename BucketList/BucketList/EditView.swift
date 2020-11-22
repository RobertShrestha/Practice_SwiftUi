//
//  EditView.swift
//  BucketList
//
//  Created by Robert Shrestha on 9/26/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI
import MapKit

// MARK: Section 9: Extending existing types to support ObservableObject 
struct EditView: View {
    // MARK: Section 10: Downloading data from Wikipedia
    enum LoadingState {
        case loading, loaded, failed
    }
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var placemark: MKPointAnnotation


    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $placemark.wrappedTitle)
                    TextField("Description", text: $placemark.wrappedSubtitle)
                }
                // MARK: Section 10: Downloading data from Wikipedia
                Section(header:Text("Nearby...")) {
                    if loadingState == .loaded {
                        List(pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                                + Text(": ") + Text(page.description)
                                    .italic()

                        }
                    } else if loadingState == .loading {
                        Text("Loading...")
                    } else {
                        Text("Please try again later")
                    }
                }
            }
        .navigationBarTitle("Edit Place")
            .navigationBarItems(trailing: Button("Done") {
                self.presentationMode.wrappedValue.dismiss()
            })
        }.onAppear(perform: fetchNearbyPlaces)
    }
    // MARK: Section 10: Downloading data from Wikipedia
    func fetchNearbyPlaces() {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(placemark.coordinate.latitude)%7C\(placemark.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                if let items = try? decoder.decode(Result.self, from: data) {
                    self.pages = Array(items.query.pages.values).sorted()
                    self.loadingState = .loaded
                    return
                }
            }
            self.loadingState = .failed
        }.resume()
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(placemark: MKPointAnnotation.example)
    }
}
