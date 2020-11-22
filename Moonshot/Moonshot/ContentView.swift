//
//  ContentView.swift
//  Moonshot
//
//  Created by Robert Shrestha on 8/9/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI
// MARK: Section 1
struct GeometryReaderView: View {
    var body: some View {
        GeometryReader { geo in
            Image("Example")
                .resizable()
                .aspectRatio(contentMode: .fill)
                //.frame(width: 300, height: 300) // this alone will not work
                .frame(width: geo.size.width)
        }
    }
}

// MARK: Section 2
struct CustomText: View {
    var text: String
    var body: some View {
        Text(text)
    }
    init(_ text: String) {
        print("Creating a new text")
        self.text = text
    }
}
// MARK: Section 2
struct ScrollViewVsList: View {
    var body: some View {
         // This load the whole 100 times at once
        ScrollView(.vertical) {
            VStack {
                ForEach(0..<100) {
                    CustomText("Item \($0)")
                        .font(.title)
                }
            }
            .frame(maxWidth: .infinity)
        }
        /*
         //This works like a lazy loading
        List {
            ForEach(0..<100) {
                CustomText("Item \($0)")
                    .font(.title)
            }
        }
        */
    }
}
// MARK: Section 3
struct NavigationLinkView: View {
    var body: some View {
        NavigationView {
            /*
             VStack {
             NavigationLink(destination: Text("Detail View")) {
             Text("Tap me")
             }
             }
             */
            // Automatically added disclouser indicator
            List {
                ForEach(0..<100) { row in
                    NavigationLink(destination: Text("Detail \(row)")) {
                        Text("\(row)")
                    }

                }
            }
            .navigationBarTitle("SwiftUI")
        }
    }
}
// MARK: Section 4
struct HierarchicalCodableView: View {
    var body: some View {
        Button("Decode JSON") {

            let input = """
         {
         "name": "Ram Shrestha",
         "address": {
         "street": "Basantpur",
         "city": "Nashville"
         }
         }
         """
            struct User: Codable {
                let name: String
                let address: Address
            }
            struct Address: Codable {
                let street: String
                let city: String
            }
            let jsonDecoder = JSONDecoder()
            let data = Data(input.utf8)

            guard let user = try? jsonDecoder.decode(User.self, from: data) else { return }

            print(user.name)

        }
    }
}
// MARK: Section 5
struct CodableDataView: View {
    let astronauts:[Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    var body: some View {
         VStack {
         Text("\(astronauts.count)")
         Text("\(missions.count)")
         }
    }
}
// MARK: Section 6
struct GenericDataView: View {
    let astronauts:[Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: Text("Detail View")) {
                    Image(mission.imageName)
                        .resizable()
                        //.aspectRatio(contentMode: .fit)
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                    VStack(alignment: .leading){
                        Text(mission.displayName)
                        //Text(mission.launchDate)
                    }
                }
                
            }
        }
    }
}
// MARK: Section 7
struct MainMissionView: View {
    let astronauts:[Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
     // MARK: Challange 3
     @State private var changeViews = false
    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: MissionView(mission: mission, astronauts: self.astronauts)) {
                    HStack {
                        Image(mission.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                        VStack(alignment: .leading) {
                            Text(mission.displayName)
                            // MARK: Challange 3
                            Text(self.changeViews ? mission.crew.map {$0.name}.joined(separator: ", "): mission.formattedLunchDate)
                            .accessibility(label: Text(""))
                                .accessibility(value: self.changeViews ? Text(mission.accessibleLaunchDate) : Text(mission.accessibleCrewNames(astronauts: self.astronauts)))
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Moonshot"))
            .navigationBarItems(leading:
                Button("Change") {
                    self.changeViews.toggle()
                }
            )
        }
    }
    
}

struct ContentView: View {
    @State private var changeViews = false
    var body: some View {
        // MARK: - Section 1 Resizing imagest to fit the screen using GeometryReader
        //GeometryReaderView()

        // MARK: - Section 2: Scroll View
        //ScrollViewVsList()

        // MARK: - Section 3: Pushing new views on the stack using navigationLink
       // NavigationLinkView()

        // MARK: - Section 4: Working with Hierarchical Codable Data
       // HierarchicalCodableView()

        // MARK: -  Section 5 : Loading a specific kind of codable Data
        //CodableDataView()

        // MARK: - Section 6 : Using generic to load any kind of Data
       // GenericDataView()

        // MARK: - Section 7: Formatting our mission view
        MainMissionView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
