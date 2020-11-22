//
//  ResortDetailsView.swift
//  SnowSeeker
//
//  Created by Robert Shrestha on 11/22/20.
//

import SwiftUI
// MARK: - Section 6: Creating a secondary view for NavigationView
struct ResortDetailsView: View {
    let resort: Resort

    var size: String {
        switch resort.size {
        case 1:
            return "Small"
        case 2:
            return "Average"
        default:
            return "Large"
        }
    }
    var price: String {
        String(repeating: "$", count: resort.price)
    }

    var body: some View {
        /*
        VStack {
            Text("Size: \(size)")
            Text("Price: \(price)")
        }
        */
        // MARK: - Section 7: Changing a view’s layout in response to size classes
        Group {
            Text("Size: \(size)")
            Spacer().frame(height: 0)
            Text("Price: \(price)")
        }
    }
}

struct ResortDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ResortDetailsView(resort: Resort.example)
    }
}
