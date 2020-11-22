//
//  AstronautView.swift
//  Moonshot
//
//  Created by Robert Shrestha on 8/12/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI

struct AstronautView: View {
    var astronaut: Astronaut
    var missions: [Mission]
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geo.size.width)
                    Text(self.astronaut.description)
                        .padding()
                    // MARK: Challange 2
                    List{
                        ForEach(self.missions) { mission in
                            HStack {
                                Image(mission.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 44, height: 44)
                                VStack(alignment: .leading) {
                                    Text(mission.displayName)
                                    Text(mission.formattedLunchDate)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name))
    }
    init(_ astronaut: Astronaut) {
        self.astronaut = astronaut
        var flewMission = [Mission]()
        let allMissions: [Mission] = Bundle.main.decode("missions.json")
        for mission in allMissions {
            if let _ = mission.crew.first(where: {
                $0.name == astronaut.id
            }){
                flewMission.append(mission)
            }
        }
        self.missions = flewMission
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    static var previews: some View {
        AstronautView(astronauts[0])
    }
}
