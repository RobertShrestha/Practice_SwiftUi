//
//  MissionView.swift
//  Moonshot
//
//  Created by Robert Shrestha on 8/12/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI


// MARK: -  Section 8: Showing mission details with ScrollView and GeometryReader
struct MissionView: View {
    var mission: Mission

    // MARK: - Section 9: Merging Codable structs using first(where:)
    struct CrewMember:Identifiable {
        let id = UUID().uuidString
        let role: String
        let astronaut: Astronaut
    }

    let astronauts: [CrewMember]

    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical) {
                VStack {
                    // MARK: Project 18 Challenge 1:Change project 8 (Moonshot) so that when you scroll down in MissionView the mission badge image gets smaller. It doesn’t need to shrink away to nothing – going down to maybe 80% is fine.
                    GeometryReader { geoImage in
                        Image(self.mission.imageName)
                        .resizable()
                        .scaledToFit()
                        .padding(.top)
                        .frame(width: geoImage.size.width, height: geoImage.size.height)
                        .scaleEffect(1 - self.scaleFactor(geometry: geo, imageGeometry: geoImage))
                        .offset(x: 0, y: self.scaleFactor(geometry: geo, imageGeometry: geoImage) * geoImage.size.height / 2)
                    }
                    .frame(height: geo.size.width * 0.75)
                    // MARK: Challange 1
                    Text(self.mission.formattedLunchDate)
                        .font(.title)
                        // MARK: Accessibilty
                        .accessibility(label: Text(""))
                        .accessibility(value: Text(self.mission.accessibleLaunchDate))
                    Text(self.mission.description)
                        .padding()
                    List {
                        ForEach(self.astronauts, id :\.role) { crew in
                            NavigationLink(destination: AstronautView(crew.astronaut)) {
                                HStack {
                                    Image(crew.astronaut.id)
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: 60, height: 60)
                                        .overlay(Circle().stroke(Color.white,lineWidth:4).shadow(radius: 10))
                                    VStack(alignment: .leading) {
                                        Text(crew.astronaut.name)
                                            .font(.headline)
                                        Text(crew.role)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .accessibilityElement(children: .ignore)
                                .accessibility(label: Text(self.getNameAndRole(crewMember: crew)))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        Spacer(minLength:25)
                    }
                }
            }
            .navigationBarTitle(Text(self.mission.displayName)
                ,displayMode: .inline)
        }

    }
    // MARK: Project 18 Challenge 1:Change project 8 (Moonshot) so that when you scroll down in MissionView the mission badge image gets smaller. It doesn’t need to shrink away to nothing – going down to maybe 80% is fine.
    func scaleFactor(geometry: GeometryProxy, imageGeometry: GeometryProxy) -> CGFloat {
        let imagePosition = imageGeometry.frame(in: .global).minY
        let safeAreaHeight = geometry.safeAreaInsets.top
        print(imagePosition, safeAreaHeight)
        return (safeAreaHeight - imagePosition) / 500

        // if zoom needs to be capped
        //return -min(0.5, (imagePosition - safeAreaHeight) / 500)
    }

    // MARK: Accessibiltiy
    func getNameAndRole(crewMember: CrewMember) -> String {
        crewMember.astronaut.accessibleName + ", " + crewMember.role
    }
    init(mission: Mission, astronauts: [Astronaut]) {
        self.mission = mission
        var matches = [CrewMember]()
        for member in mission.crew {
            if let match = astronauts.first(where: {
                $0.id == member.name
            }) {
                matches.append(CrewMember(role: member.role, astronaut: match))
            } else {
                fatalError("missing \(member)")
            }
        }
        self.astronauts = matches
    }
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts:[Astronaut] = Bundle.main.decode("astronauts.json")
    static var previews: some View {
        MissionView(mission: missions[0], astronauts: astronauts)
    }
}
