//
//  LockView.swift
//  BucketList
//
//  Created by Robert Shrestha on 9/27/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI
import LocalAuthentication
struct LockView: View {
    @Binding var isUnlocked: Bool
    // MARK: Challange 3: Our app silently fails when errors occur during biometric authentication. Add code to show those errors in an alert, but be careful: you can only add one alert() modifier to each view.
    @State private var showAlert = false
    var body: some View {
        Button("Unlock Places") {
            self.authenticate()
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .clipShape(Capsule())
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error with Authentication"),
                  message: Text("Try again"),
                  dismissButton: .default(Text("Ok")))
        }
    }
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, authenticationError) in
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    } else {
                        self.showAlert = true
                    }
                }
            }
        } else {
            // no biometric
        }
    }
}
