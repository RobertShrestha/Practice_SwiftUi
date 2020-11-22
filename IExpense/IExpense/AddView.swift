//
//  AddView.swift
//  IExpense
//
//  Created by Robert Shrestha on 8/9/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expenses: Expenses
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    
     // MARK: - Challange 3
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    var typeArray = ["Personal", "Business"]
    var body: some View {
        NavigationView {
            Form {
                TextField("Enter name", text: $name)
                Picker("Enter Type",selection: $type) {
                    ForEach(typeArray, id:\.self) {
                        Text($0)
                    }
                }
                TextField("Enter Amount",text: $amount).keyboardType(.numberPad)
            }
        .navigationBarTitle("Add new expenses")
        .navigationBarItems(trailing:
            Button("Save") {
                if let actualAmount = Int(self.amount) {
                    let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                    self.expenses.items.append(item)
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                     // MARK: - Challange 3
                    self.alertTitle = "Something went wrong !!!!"
                    self.alertMessage = "Amount should be in Int"
                    self.showingAlert = true
                }
            }
            )
                // MARK: - Challange 3
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(self.alertTitle), message: Text(self.alertMessage), dismissButton: .default(Text("Ok")))
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
