//
//  ContentView.swift
//  HotProspects
//
//  Created by Robert Shrestha on 10/3/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI

import SamplePackage
// MARK: - Section 1 Reading custom values with @EnvironmentObject

class User: ObservableObject {
    @Published var name = "Taylor Swift"
}

struct EditView: View {
    @EnvironmentObject var user: User

    var body: some View {
        TextField("Name", text: $user.name)
    }
}
struct DisplayView: View {
    @EnvironmentObject var user: User

    var body: some View {
        Text(user.name)
    }
}

struct SectionOneView: View {
    let user = User()
    var body: some View {
        VStack {
            EditView()
         //       .environmentObject(user)
            DisplayView()
         //       .environmentObject(user)
        }
    .environmentObject(user)
    }
}

// MARK: - Section 2: Creating tabs with TabView and tabItem()

struct SectionTwoView: View {
    @State private var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Tab 1")
                .tabItem {
                    Image(systemName: "star")
                    Text("One")
            }
            .tag(0)

            Text("Tab 2")
                .tabItem{
                    Image(systemName: "star.fill")
                    Text("Two")
            }
            .tag(1)
        }
    }
}

// MARK:  Section 3: Understanding Swift’s Result type
enum NetworkError: Error {
    case badURL, requestFailed, unknown
}
struct SectionThreeView: View {
    var body: some View {
        Text("Hello World")
            .onAppear {
                self.fetchData(from: "https://www.apple.com") { (result) in
                    switch result {
                    case .success(let str):
                        print(str)
                    case .failure(let error):
                        switch error {
                        case .badURL:
                            print("Bad URL")
                        case .requestFailed:
                            print("Network problems")
                        case .unknown:
                            print("Unknown Error")
                        }
                    }
                }
        }
    }

    func fetchData(from urlString: String, completion: @escaping ((Result<String,NetworkError>) -> Void)) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    let stringData = String(decoding: data, as: UTF8.self)
                    completion(.success(stringData))
                } else if error != nil {
                    completion(.failure(.requestFailed))
                } else {
                    completion(.failure(.unknown))
                }
            }
        }.resume()
    }
}

// MARK: Section 4: Manually publishing ObservableObject changes

class  DelayedUpdater: ObservableObject {
    var value = 0 {
        willSet {
            objectWillChange.send()
        }
    }
    init() {
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                self.value += 1
            }
        }
    }
}
struct SectionFourView: View {
   @ObservedObject var delayUpdater = DelayedUpdater()
    var body: some View {
        Text("The value is \(delayUpdater.value)")
    }
}

// MARK: Section 5: Controlling image interpolation in SwiftUI

struct SectionFiveView: View {
    var body: some View {
        Image("example")
            .interpolation(.high)
        .resizable()
        .scaledToFit()
            .frame(maxHeight: .infinity)
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
    }
}

// MARK: Section 6: Creating context menus

struct SectionSixView: View {
    @State var backgroundColor = Color.red
    var body: some View {
        VStack {
            Text("Hello World")
            .padding()
            .background(backgroundColor)

            Text("Change Color")
            .padding()
                .contextMenu {
                    Button(action: {
                        self.backgroundColor = .red
                    }, label: {
                        Text("Red")
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.red)
                    })
                    Button(action: {
                        self.backgroundColor = .green
                    }, label: {
                        Text("Green")
                    })
                    Button(action: {
                        self.backgroundColor = .blue
                    }, label: {
                        Text("Blue")
                    })
            }
        }
    }
}
// MARK: Section 7: Scheduling local notifications
struct SectionSevenView: View {
    var body: some View {
        VStack(spacing: 10.0) {
            Button("Request Permission") {
                UNUserNotificationCenter.current()
                    .requestAuthorization(options: [.alert,.badge,.sound]) { (success, error) in
                        if success {
                            print("All set!")
                        } else if let error = error {
                            print(error.localizedDescription)
                        }
                }
            }

            Button("Schedule Notification") {
                let content = UNMutableNotificationContent()
                content.title = "Feed the dog"
                content.subtitle = "It looks hungry"
                content.sound = UNNotificationSound.default

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)


            }
        }
    }
}
// MARK: Section 8: Adding Swift package dependencies in Xcode
struct SectionEightView: View {
    let possibleNumber = Array(1...60)

    var results: String {
        let selected = possibleNumber.random(7).sorted()
        let strings = selected.map(String.init)
        return strings.joined(separator: ", ")
    }
    var body: some View {
        Text(results)
    }
}
// MARK: Section 9: Building our tab bar
struct MainView: View {
    var prospects = Prospects()
    var body: some View {
        TabView {
            ProspectsView(filter: .none)
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Everyone")
            }
            ProspectsView(filter: .contacted)
                .tabItem {
                    Image(systemName: "checkmark.circle")
                    Text("Contacted")
            }
            ProspectsView(filter: .uncontacted)
                .tabItem {
                    Image(systemName: "questionmark.diamond")
                    Text("Uncontacted")
            }
            MeView()
                .tabItem {
                    Image(systemName: "person.crop.square")
                    Text("Me")
            }
        }
    .environmentObject(prospects)
    }
}
struct ContentView: View {
    var body: some View {
       // MARK: - Section 1 Reading custom values with @EnvironmentObject
       // SectionOneView()

        // MARK: - Section 2: Creating tabs with TabView and tabItem()
        //SectionTwoView()

        // MARK:  Section 3: Understanding Swift’s Result type
       // SectionThreeView()

        // MARK: Section 4: Manually publishing ObservableObject changes
        //SectionFourView()

        // MARK: Section 5: Controlling image interpolation in SwiftUI
       //SectionFiveView()

        // MARK: Section 6: Creating context menus
        //SectionSixView()

        // MARK: Section 7: Scheduling local notifications
        //SectionSevenView()

        // MARK: Section 8: Adding Swift package dependencies in Xcode
        //SectionEightView()

        // MARK: Section 9: Building our tab bar
        MainView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
