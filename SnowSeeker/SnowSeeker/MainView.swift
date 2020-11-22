//
//  MainView.swift
//  SnowSeeker
//
//  Created by Robert Shrestha on 11/22/20.
//

import SwiftUI

struct MainView: View {
    // MARK: - Challange 3: For a real challenge, let the user sort and filter the resorts in ContentView. For sorting use default, alphabetical, and country, and for filtering let them select country, size, or price.
    enum SortingType {
        case none, alphabetical , country
    }
    var sortedResorts: [Resort]  {
        switch sortingType {
        case .none:
            return resorts
        case .alphabetical:
            return resorts.sorted(by: {$0.name > $1.name})
        case .country:
            return resorts.sorted(by: {$0.country > $1.country})
        }
    }

    var filteredResorts: [Resort] {
        var tempResorts = sortedResorts

        tempResorts = tempResorts.filter { (resort) -> Bool in
            resort.country == self.selectedCountry || self.selectedCountry == "All"
        }

        tempResorts = tempResorts.filter { (resort) -> Bool in
            resort.size == self.selectedSize || self.selectedSize == 0
        }

        tempResorts = tempResorts.filter { (resort) -> Bool in
            resort.price == self.selectedPrice || self.selectedPrice == 0
        }


        return tempResorts
    }
    @State private var isShowingSortedActionSheet = false
    @State private var isShowingFilterView = false
    @State private var sortingType: SortingType = .none


    @State private var selectedCountry: String = "All"
    @State private var selectedSize: Int = 0
    @State private var selectedPrice: Int = 0
    // MARK: Section 9: Letting the user mark favorites
    @ObservedObject var favorites = Favorites()

    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    var body: some View {
        NavigationView {
            List(filteredResorts) { resort in
                //NavigationLink(destination: Text(resort.name)) {

                // MARK: - Section 6: Creating a secondary view for NavigationView
                NavigationLink(destination: ResortView(resort: resort)) {
                    ResortListView(resort: resort)
                }
            }

            // MARK: - Challange 3: For a real challenge, let the user sort and filter the resorts in ContentView. For sorting use default, alphabetical, and country, and for filtering let them select country, size, or price.
            .navigationBarItems(leading:

                                    HStack {
                                        Button(action: {
                                            self.isShowingSortedActionSheet = true
                                        }, label: {
                                            Image(systemName: "arrow.up.arrow.down.circle.fill")
                                        })
                                        NavigationLink(
                                            destination: FilterView(selectCountry: $selectedCountry, selectedSize: $selectedSize, selectedPrice: $selectedPrice)) {
                                            Image(systemName: "line.horizontal.3.decrease")
                                        }
                                    }
            )


            .navigationTitle("Resorts")
            // MARK: Section 5: Making NavigationView work in landscape
            WelcomeView()

        }
        .onAppear()
        // MARK: - Challange 3: For a real challenge, let the user sort and filter the resorts in ContentView. For sorting use default, alphabetical, and country, and for filtering let them select country, size, or price.
//        .sheet(isPresented: $isShowingFilterView, content: {
//            //FilterView()
////            FilterView(selectCountry: $selectedCountry, selectedSize: $selectedSize, selectedPrice: $selectedPrice)
//        })
        .actionSheet(isPresented: $isShowingSortedActionSheet) {
            ActionSheet(title: Text("Sort"), buttons: [
                .default(Text("None"), action: { self.sortingType = .none}),
                .default(Text("Alphabetical"), action: { self.sortingType = .alphabetical}),
                .default(Text("Country"), action: { self.sortingType = .country})
            ])
        }



        // MARK: Section 9: Letting the user mark favorites
        .environmentObject(favorites)

        // MARK: Section 5: Making NavigationView work in landscape
        // .phoneOnlyStackNavigation()
    }
    func filter() {
        if self.selectedCountry != "All" {
            self.sortingType = .none
        }

    }
}

struct ResortListView: View {
    var resort: Resort
    @EnvironmentObject var favorites: Favorites
    var body: some View {
        Image(resort.country)
            .resizable()
            .scaledToFill()
            .frame(width: 40, height: 25)
            .clipShape(
                RoundedRectangle(cornerRadius: 5)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.black, lineWidth: 1)
            )
        VStack(alignment: .leading) {
            Text(resort.name)
                .font(.headline)
            Text("\(resort.runs) runs")
                .foregroundColor(.secondary)

        }
        .layoutPriority(1)
        if self.favorites.contains(resort) {
            Spacer()
            Image(systemName: "heart.fill")
                .accessibility(label: Text("This is a favorite resort"))
                .foregroundColor(.red)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
