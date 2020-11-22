//
//  ResortView.swift
//  SnowSeeker
//
//  Created by Robert Shrestha on 11/22/20.
//

import SwiftUI

// MARK: - Section 6: Creating a secondary view for NavigationView
struct ResortView: View {

    // MARK: - Section 7: Changing a view’s layout in response to size classes
    @Environment(\.horizontalSizeClass) var sizeClass

    // MARK: - Section 8: Binding an alert to an optional string
    //@State private var selectedFacility: String?

    // MARK: - Section 8: Binding an alert to an optional string
    // Second Method
    @State private var selectedFacility: Facility?

    // MARK: Section 9: Letting the user mark favorites
    @EnvironmentObject var favorites: Favorites

    var resort: Resort
    var body: some View {
        ScrollView {
            VStack(alignment: .leading,spacing: 0) {
                /*
                Image(decorative: resort.id)
                    .resizable()
                    .scaledToFit()
                */

                // MARK: Challange 1: Add a photo credit over the ResortView image. The data is already loaded from the JSON for this purpose, so you just need to make it look good in the UI.
                ZStack(alignment: .bottomTrailing) {
                    Image(decorative: resort.id)
                    .resizable()
                    .scaledToFit()

                    //Spacer()
                    Text(resort.imageCredit)
                        .font(.caption)
                        .padding(5)
                        .background(Color.secondary)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .padding([.bottom,.trailing], 10)
                }
                Group {
                    /*
                    HStack {
                        Spacer()
                        ResortDetailsView(resort: resort)
                        SkiDetailsView(resort: resort)
                        Spacer()
                    }
                    */

                    // MARK: - Section 7: Changing a view’s layout in response to size classes
                    HStack {
                        if sizeClass == .compact {
                            Spacer()
                            VStack {
                                ResortDetailsView(resort: resort)
                            }
                            VStack {
                                SkiDetailsView(resort: resort)
                            }
                            Spacer()
                        } else {
                            ResortDetailsView(resort: resort)
                            Spacer().frame(height: 0)
                            SkiDetailsView(resort: resort)
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.top)

                    Text(resort.resortDescription)
                        .padding(.vertical)
                    Text("Facilities")
                        .font(.headline)

                    //Text(resort.facilities.joined(separator: ", "))
                       // .padding(.vertical)
                    /*
                    Text(ListFormatter.localizedString(byJoining: resort.facilities))
                        .padding(.vertical)
                    */

                    // MARK: - Section 8: Binding an alert to an optional string
                    HStack {
                        // Second Method
                        /*
                        ForEach(resort.facilities, id: \.self) { facility in
                            Facility.icon(for: facility)
                                .font(.title)
                                .onTapGesture {
                                    self.selectedFacility = facility
                                }
                        }
                        */

                        ForEach(resort.facilityTypes) { facility in
                            facility.icon
                                .font(.title)
                                .onTapGesture {
                                    self.selectedFacility = facility
                                }
                        }
                    }
                    .padding(.vertical)
                }
                .padding(.horizontal)

                // MARK: Section 9: Letting the user mark favorites
                Button(favorites.contains(resort) ? "Remove from Favourites" : "Add to Favourites") {
                    if self.favorites.contains(self.resort) {
                        self.favorites.remove(self.resort)
                    } else {
                        self.favorites.add(self.resort)
                    }
                }
                .padding()
                
            }
        }
        .navigationBarTitle(Text("\(resort.name) \(resort.country)"), displayMode: .inline)
        .alert(item: $selectedFacility) { facility in
            facility.alert
        }
    }
}
// MARK: - Section 8: Binding an alert to an optional string
// Second Method
/*
extension String: Identifiable {
    public var id: String { self }
}
*/

struct ResortView_Previews: PreviewProvider {
    static var previews: some View {
        ResortView(resort: Resort.example)
    }
}
