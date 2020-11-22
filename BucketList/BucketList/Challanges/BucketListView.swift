//
//  BucketListView.swift
//  BucketList
//
//  Created by Robert Shrestha on 9/27/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI
import MapKit
import LocalAuthentication
struct BucketListView: View {
    @State private var isUnlocked = false
    var body: some View {
        ZStack {
            if isUnlocked {
                UnlockView()
            } else {
                LockView(isUnlocked: $isUnlocked)
            }
        }
    }
}

struct BucketListView_Previews: PreviewProvider {
    static var previews: some View {
        BucketListView()
    }
}
