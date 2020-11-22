//
//  RatingView.swift
//  Bookworm
//
//  Created by Robert Shrestha on 8/31/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI
// MARK: Section 5: Adding a custom star rating component
struct RatingView: View {
    @Binding var rating : Int
    var label = ""
    var maximumRating = 5

    var offImage: Image?
    var onImage = Image(systemName: "star.fill")

    var offColor = Color.gray
    var onColor = Color.yellow



    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
            }
            ForEach(1..<maximumRating + 1) { number in
                self.image(for: number)
                    .foregroundColor(number > self.rating ? self.offColor : self.onColor)
                    .onTapGesture {
                        self.rating = number
                }
                // MARK: Accessibility
                    .accessibility(label: Text("\(number == 1 ? "1 star" : "\(number) stars")"))
                    .accessibility(removeTraits: .isImage)
                    .accessibility(addTraits: number > self.rating ? .isButton : [.isButton, .isSelected])
            }
        }
    }
    func image(for number:Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(4))
    }
}
