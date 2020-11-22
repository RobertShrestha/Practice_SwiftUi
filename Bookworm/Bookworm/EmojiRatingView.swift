//
//  EmojiRatingView.swift
//  Bookworm
//
//  Created by Robert Shrestha on 9/7/20.
//  Copyright © 2020 robert. All rights reserved.
//
// MARK: Section 6: Building a list with @FetchRequest
import SwiftUI

struct EmojiRatingView: View {
    var rating: Int16
    var body: some View {
        switch rating {
        case 1:
            return Text("😴")
        case 2:
           return Text("😟")
        case 3:
           return Text("😕")
        case 4:
           return Text("😀")
        default:
          return  Text("🤩")
        }
    }
}

struct EmojiRatingView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiRatingView(rating: 3)
    }
}
