//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Robert Shrestha on 10/3/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI
import CodeScanner
import UserNotifications

struct ProspectsView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }

    // MARK: Challenge 3: Use an action sheet to customize the way users are sorted in each screen – by name or by most recent.
    enum sortedType {
        case name, recent
    }
    // MARK: Section 10: Sharing data across tabs using @EnvironmentObject
    @EnvironmentObject var prospects: Prospects

    // MARK: Section 13: Scanning QR codes with SwiftUI
    @State private var isShowingScanner = false
    @State private var isShowingActionSheet = false
    @State private var isSortedByName = true
    @State private var sort: sortedType = .name

    let filter: FilterType

    var title: String {
        switch filter {

        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted People"
        case .uncontacted:
            return "Uncontacted People"
        }
    }
    // MARK: Section 11: Dynamically filtering a SwiftUI List
    var filteredProspects: [Prospect] {
        switch filter {

        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter {$0.isContacted }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted }
        }
    }

     // MARK: Challenge 3: Use an action sheet to customize the way users are sorted in each screen – by name or by most recent.
    var sortedProspects : [Prospect] {
        switch sort {
        case .name:
            return filteredProspects.sorted(by: {$0.name < $1.name})
        case .recent:
            return filteredProspects.sorted(by: {$0.createDate < $1.createDate})
        }
    }
    var body: some View {
        NavigationView {
             // MARK: Section 10: Sharing data across tabs using @EnvironmentObject
            //Text("People: \(prospects.people.count)")

            // MARK: Section 11: Dynamically filtering a SwiftUI List
            List {
                ForEach(sortedProspects) { prospect in
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }

                        // MARK: Challenge 1: Add an icon to the “Everyone” screen showing whether a prospect was contacted or not.
                        Spacer()
                        if prospect.isContacted {
                            Image(systemName: "checkmark.circle")
                        }
                    }
                        // MARK: Section 14: Adding options with a context menu
                    .contextMenu {
                        Button(prospect.isContacted ? "Mark Uncontacted" : "Mark contacted") {
                            self.prospects.toggle(prospect)
                        }
                        if !prospect.isContacted {
                            Button("Remind Me") {
                                self.addNotification(for: prospect)
                            }
                        }
                    }

                }
            }
            .navigationBarTitle(title)
            .navigationBarItems(leading:
                 // MARK: Challenge 3: Use an action sheet to customize the way users are sorted in each screen – by name or by most recent.
            Button(action: {
                self.isShowingActionSheet = true
            }, label: {
                Image(systemName: "line.horizontal.3.decrease.circle.fill")
                Text("Filter")
            }),trailing: Button(action: {

                // MARK: Section 13: Scanning QR codes with SwiftUI
                self.isShowingScanner = true

                /*
                let prospect = Prospect()
                prospect.name = "Axe"
                prospect.emailAddress = "hireme.robert@gmail.com"
                self.prospects.people.append(prospect)
                */
            }, label: {
                Image(systemName: "qrcode.viewfinder")
                Text("Scan")
            }))
            .sheet(isPresented: $isShowingScanner) {
                    CodeScannerView(codeTypes: [.qr], simulatedData: "C\nhireme2.robert@gmail.com", completion: self.handleScan)
            }
                 // MARK: Challenge 3: Use an action sheet to customize the way users are sorted in each screen – by name or by most recent.
            .actionSheet(isPresented: $isShowingActionSheet) {
                ActionSheet(title: Text("Fliter"), buttons: [
                    .default(Text("Sort by name"), action: {self.sort = .name}),
                    .default(Text("Sort by most recent"), action: {self.sort = .recent}),
                    .cancel()
                ])
            }
        }
    }


    // MARK: Section 13: Scanning QR codes with SwiftUI
    func handleScan(result:Result<String, CodeScannerView.ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            //self.prospects.add(person)
            self.prospects.addInDoc(person)
        case .failure(let error):
            print("Scanning Failed \(error.localizedDescription)")
        }
    }
    // MARK: Section 16: posting notifications to the lock screen
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default

            /*
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            */
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        center.getNotificationSettings { (setting) in
            if setting.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
                    if success {
                        addRequest()
                    } else {
                        print("Doh")
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
