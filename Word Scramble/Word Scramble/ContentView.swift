//
//  ContentView.swift
//  Word Scramble
//
//  Created by Robert Shrestha on 8/3/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI

// MARK: Section 1:

struct ListView: View {
    let people = ["Ram", "Sita", "Hari", "Shyam","Gita"]
    var body: some View {
        /*
         List {
         //            Text("Hello, World!")
         //            Text("Hello, World!")
         //            Text("Hello, World!")
         //            Text("Hello, World!")

         Section(header:Text("Section 1")){
         Text("Static row 0")
         Text("Static row 1")
         }
         Section(header:Text("Section 2")){
         ForEach(0..<5, id: \.self){
         Text("Dynamic row \($0)")
         }
         }
         Section(header:Text("Section 3")){
         Text("Static row 2")
         Text("Static row 3")
         }

         }
         .listStyle(GroupedListStyle())
         */
        /*
         List(0..<5,id: \.self) {
         Text("Dynamic row \($0)")
         }
         .listStyle(GroupedListStyle())
         */
        /*
         List(people, id:\.self) {
         Text($0)
         }
         */

        List {
            ForEach(people, id:\.self) {
                Text($0)
            }
        }
    }
}

// MARK: Section 2
struct LoadingResourceView: View {
    var body: some View {
         Text("Hello World")
//         if let fileURL = Bundle.main.url(forResource: "some-file", withExtension: "txt") {
//         if let fileContents = try? String(contentsOf: fileURL) {
//            print(fileContents)
//         }
//        }

    }
}
// MARK: Section 3
struct WorkingWithStringView: View {
    var body: some View {

         /*
         let input = "a b c"
         let letters = input.components(separatedBy: " ")
         let letter = letters.randomElement()
         let trimmed = letter?.trimmingCharacters(in: .whitespacesAndNewlines)
         */


         /*
         let word = "swift"
         let checker = UITextChecker()
         let range = NSRange(location: 0, length: word.utf16.count)
         let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
         let allGood = misspelledRange.location == NSNotFound
         */

         return Text("Hello World")
    }
}

// MARK: Main View

struct MainView: View{
    // MARK: Section 1: List
    //let people = ["Ram", "Sita", "Hari", "Shyam","Gita"]

    // Section 4: Adding to a list of world
    @State private var rootWord = ""
    @State private var usedWords:[String] = []
    @State private var newWord = ""

    // Section 6
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var isPresented = false

    var totalScore: Int {
        get {
            let counts = usedWords.map({$0.count})
            return counts.reduce(0,+)
        }
        set {}
    }

    var body: some View {

        // MARK: Section 1: List
        // ListView()


        // MARK:  Section 2: Loading resources
        // LoadingResourceView()

        // MARK: Section 3: Working with string
        // WorkingWithStringView()


        // MARK: Section 4: Adding list of word
        NavigationView {
            VStack {
                TextField("Enter your world", text: $newWord, onCommit: addNewWord).textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                List(usedWords, id: \.self) {
                    Image(systemName: "\($0.count).circle")
                    Text($0)
                }
                Text("The total scorce is \(totalScore)")
            }.alert(isPresented: $isPresented){
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("Ok")))
            }
            .navigationBarTitle(rootWord)
                // MARK: Section 5
                .onAppear(perform: startGame)
                .navigationBarItems(leading:
                    Button(action: startGame) {
                        Text("Restart")
                    }
            )
        }
    }
    func addNewWord() {
        let answer = newWord.lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }

        guard isOriginal(word: answer) else {
            wordError(title: "Word already used", message: "Be more original")
            return
        }
        guard isPossible(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        guard isReal(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word")
            return
        }


        self.usedWords.insert(answer, at: 0)
        newWord = ""
    }

    // MARK: Section 5: Running code when our app launches
    func startGame() {
        newWord = ""
        usedWords.removeAll()
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
            }
        }
    }
    // MARK:  Section 6: Validating words with UITextChecker
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }

    func isPossible(word: String) -> Bool {
        var tempWord = rootWord.lowercased()
        for letter in word{
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            }else {
                return false
            }
        }
        return true
    }

    func isReal(word: String) -> Bool {
        // Challange Task
        guard word.count >= 3 else { return false }
        //guard word.first != rootWord.first else { return false }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }

    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        isPresented = true
    }

}

// MARK: Accessibility View
struct AccessibilityView: View{
    // MARK: Section 1: List
    //let people = ["Ram", "Sita", "Hari", "Shyam","Gita"]

    // Section 4: Adding to a list of world
    @State private var rootWord = ""
    @State private var usedWords:[String] = []
    @State private var newWord = ""

    // Section 6
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var isPresented = false

    var totalScore: Int {
        get {
            let counts = usedWords.map({$0.count})
            return counts.reduce(0,+)
        }
        set {}
    }

    var body: some View {

        // MARK: Section 1: List
        // ListView()


        // MARK:  Section 2: Loading resources
        // LoadingResourceView()

        // MARK: Section 3: Working with string
        // WorkingWithStringView()


        // MARK: Section 4: Adding list of word
        NavigationView {
            VStack {
                TextField("Enter your world", text: $newWord, onCommit: addNewWord).textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                List(usedWords, id: \.self) { word in
                    HStack {
                        Image(systemName: "\(word.count).circle")
                        Text(word)
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibility(label: Text("\(word), \(word.count) letters"))
                }
                Text("The total scorce is \(totalScore)")
            }.alert(isPresented: $isPresented){
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("Ok")))
            }
            .navigationBarTitle(rootWord)
                // MARK: Section 5
                .onAppear(perform: startGame)
                .navigationBarItems(leading:
                    Button(action: startGame) {
                        Text("Restart")
                    }
            )
        }
    }
    func addNewWord() {
        let answer = newWord.lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }

        guard isOriginal(word: answer) else {
            wordError(title: "Word already used", message: "Be more original")
            return
        }
        guard isPossible(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        guard isReal(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word")
            return
        }


        self.usedWords.insert(answer, at: 0)
        newWord = ""
    }

    // MARK: Section 5: Running code when our app launches
    func startGame() {
        newWord = ""
        usedWords.removeAll()
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
            }
        }
    }
    // MARK:  Section 6: Validating words with UITextChecker
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }

    func isPossible(word: String) -> Bool {
        var tempWord = rootWord.lowercased()
        for letter in word{
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            }else {
                return false
            }
        }
        return true
    }

    func isReal(word: String) -> Bool {
        // Challange Task
        guard word.count >= 3 else { return false }
        //guard word.first != rootWord.first else { return false }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }

    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        isPresented = true
    }

}
struct ContentView: View{
    var body: some View {

        // MARK: Section 1: List
       // ListView()


        // MARK:  Section 2: Loading resources
       // LoadingResourceView()

        // MARK: Section 3: Working with string
       // WorkingWithStringView()


        // MARK: Section 4: Adding list of word
        //MainView()

        // MARK: Accessibility View
        AccessibilityView()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
