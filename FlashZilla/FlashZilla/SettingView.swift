//
//  SettingView.swift
//  FlashZilla
//
//  Created by Robert Shrestha on 11/19/20.
//

import SwiftUI

struct SettingView: View {

    // MARK: Challange 2: Add a settings screen that has a single option: when you get an answer one wrong that card goes back into the array so the user can try it again.

    @Environment(\.presentationMode) var presentationMode

    @Binding var dontRemoveCard: Bool
    var body: some View {
        NavigationView {
            List {
                Toggle("Card goes into the deck when answer is wrong", isOn: $dontRemoveCard)
            }
            .navigationTitle("Setting")
            .navigationBarItems(trailing: Button("Done",action: dismiss))
            .listStyle(GroupedListStyle())
        }

    }
    func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        let reuseWrongCard = Binding.constant(false)
        SettingView(dontRemoveCard: reuseWrongCard)
    }
}
