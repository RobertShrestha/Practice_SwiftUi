//
//  CircleView.swift
//  BucketList
//
//  Created by Robert Shrestha on 9/27/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI

struct CircleView: View {
    var body: some View {
        Circle()
            .fill(Color.blue)
            .opacity(0.3)
            .frame(width: 32, height: 32)
    }
}

struct CircleView_Previews: PreviewProvider {
    static var previews: some View {
        CircleView()
    }
}
