//
//  SkiDetailsView.swift
//  SnowSeeker
//
//  Created by Robert Shrestha on 11/22/20.
//

import SwiftUI
// MARK: - Section 6: Creating a secondary view for NavigationView
struct SkiDetailsView: View {
    var resort: Resort
    var body: some View {
        /*
        VStack {
            Text("Elevation:\(resort.elevation)m")
            Text("Snow: \(resort.snowDepth)cm")
        }
        */

        // MARK: - Section 7: Changing a view’s layout in response to size classes
        Group {
            Text("Elevation:\(resort.elevation)m")
            Spacer().frame(height: 0)
            Text("Snow: \(resort.snowDepth)cm")
        }
    }
}

struct SkiDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        SkiDetailsView(resort: Resort.example)
    }
}
