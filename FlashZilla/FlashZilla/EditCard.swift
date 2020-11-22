//
//  EditCard.swift
//  FlashZilla
//
//  Created by Robert Shrestha on 11/16/20.
//

import SwiftUI
// MARK: Section 15: Adding and deleting cards
struct EditCard: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var cards = [Card]()
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Add new card")) {
                    TextField("Prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button(action: {
                        addCard()
                    }, label: {
                        Text("Add Card")
                    })
                }
                Section {
                    ForEach(0..<cards.count, id:\.self) { index in
                        VStack(alignment: .leading) {
                            Text(self.cards[index].prompt)
                                .font(.headline)
                            Text(self.cards[index].answer)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform:removeCard)
                }
            }
            .navigationTitle("Edit Cards")
            .navigationBarItems(trailing: Button("Done",action: dismiss))
            .listStyle(GroupedListStyle())
            .onAppear(perform:loadData)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let cards = try? JSONDecoder().decode([Card].self, from: data) {
                self.cards = cards
            }
        }
    }

    func saveData() {
        if let data = try? JSONEncoder().encode(cards) {
            UserDefaults.standard.setValue(data, forKey: "Cards")
        }
    }
    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }
        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        cards.insert(card, at: 0)
        saveData()
    }
    func removeCard(at index: IndexSet) {
        self.cards.remove(atOffsets: index)
        saveData()
    }


    func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct EditCard_Previews: PreviewProvider {
    static var previews: some View {
        EditCard()
    }
}
