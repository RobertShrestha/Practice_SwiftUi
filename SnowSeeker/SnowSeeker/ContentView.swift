//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Robert Shrestha on 11/22/20.
//

import SwiftUI

// MARK: - Section 1: Working with two side by side views in SwiftUI

struct SectionOne: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination: Text("New Secondary")){
            Text("Hello, world!")
        }
                .navigationBarTitle("Primary")
            Text("Secondary")
        }
    }
}
// MARK: - Section 2: Using alert() and sheet() with optionals
struct User: Identifiable {
    var id = "Eric Cartmen"
}
struct SectionTwo: View {
    // New way
    @State private var selectedUser: User? = nil
    // Old way
    @State private var isShowingAlert = false
    var body: some View {
        Text("Hello world")
            .onTapGesture {
                self.selectedUser = User()
                self.isShowingAlert = true
            }
            //New way
            /*
            .alert(item: $selectedUser) { user in
                Alert(title: Text(user.id))
            }
            */

            //Old way
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text(selectedUser!.id))
            }
    }
}
// MARK: - Section 3: Using groups as transparent layout containers
struct UserView: View {
    var body: some View {
        Group {
            Text("Name: Robert")
            Text("Country: Nepal")
            Text("Pets: Pika, Fuchhi, Mabel, and Dipper")
        }
    }
}
struct SectionThree: View {
    @State private var layoutVertically = false

    @Environment(\.horizontalSizeClass) var sizeClass
    var body: some View {
        Group {
            if sizeClass == .compact {
                 //VStack(content:UserView.init())
                 VStack {
                    UserView ()
                 }

            } else {
                // HStack(content:UserView.init())
                 HStack {
                    UserView ()
                 }

            }
        }
        /*
        Group {
            if layoutVertically {
                VStack {
                    UserView()
                }
            } else {
                HStack {
                    UserView()
                }
            }
        }
        .onTapGesture {
            self.layoutVertically.toggle()
        }
        */


    }
}

// MARK: - Section 4: Building a primary list of items
/*
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
    @State private var isShowingSortedActionSheet = false
    @State private var sortingType: SortingType = .none
    // MARK: Section 9: Letting the user mark favorites
    @ObservedObject var favorites = Favorites()

    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    var body: some View {
        NavigationView {
            List(sortedResorts) { resort in
               //NavigationLink(destination: Text(resort.name)) {

                    // MARK: - Section 6: Creating a secondary view for NavigationView
                NavigationLink(destination: ResortView(resort: resort)) {
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
            .navigationBarItems(leading:
                    Button(action: {
                        self.isShowingSortedActionSheet = true
                    }, label: {
                        Image(systemName: "arrow.up.arrow.down.circle.fill")
                    })
            )
            .action
            .navigationTitle("Resorts")
            // MARK: Section 5: Making NavigationView work in landscape
            WelcomeView()
        }

        // MARK: Section 9: Letting the user mark favorites
        .environmentObject(favorites)

        // MARK: Section 5: Making NavigationView work in landscape
       // .phoneOnlyStackNavigation()
    }
}
*/
// MARK: Section 5: Making NavigationView work in landscape
extension View {
    func phoneOnlyStackNavigation()-> some View {
        if UIDevice.current.userInterfaceIdiom  == .phone {
            return
                AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
}
struct ContentView: View {
    var body: some View {
        // MARK: Section 1: Working with two side by side views in SwiftUI
        //SectionOne()

        // MARK: Section 2: Using alert() and sheet() with optionals
        //SectionTwo()

        // MARK: - Section 3: Using groups as transparent layout containers
        //SectionThree()

        // MARK: - Section 4: Building a primary list of items
        MainView()

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
