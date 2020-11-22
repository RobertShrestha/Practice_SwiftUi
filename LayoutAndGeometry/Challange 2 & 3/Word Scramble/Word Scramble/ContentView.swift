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
                GeometryReader { geo in
                    List(self.usedWords, id: \.self) { word in
                        GeometryReader { itemGeo in
                            HStack {
                                Image(systemName: "\(word.count).circle")
                                    .foregroundColor(self.getColor(listProxy: geo, itemProxy: itemGeo))
                                Text(word)
                            }
                            // MARK: Project 18 - Challenge 2: Change project 5 (Word Scramble) so that words towards the bottom of the list slide in from the right as you scroll. Ideally at least the top 8-10 words should all be positioned normally, but after that they should be offset increasingly to the right.
                            .frame(width: itemGeo.size.width, alignment: .leading)
                            .offset(x: self.getOffset(listProxy: geo, itemProxy: itemGeo), y: 0)
                        }
                    }
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


    // MARK: Project 18 - Challenge 3: For a real challenge make the letter count images in project 5 change color as you scroll. For the best effect, you should create colors using the Color(red:green:blue:) initializer, feeding in values for whichever of red, green, and blue you want to modify. The values to input can be figured out using the row’s current position divided by maximum position, which should give you values in the range 0 to 1.
    func getColor(listProxy: GeometryProxy, itemProxy: GeometryProxy) -> Color {
        let itemPercent = getItemPercent(listProxy: listProxy, itemProxy: itemProxy)

        let colorValue = Double(itemPercent / 100)

        // varying from green to red going through yellow,
        // using Color(red:green:blue:) as suggested
        return Color(red: 2 * colorValue, green: 2 * (1 - colorValue), blue: 0)

        // varying hue is easier to work with and offers more variety though
        //return Color(hue: colorValue, saturation: 0.9, brightness: 0.9)
    }

    // Project 18 - Challenge 3
    func getItemPercent(listProxy: GeometryProxy, itemProxy: GeometryProxy) -> CGFloat {
        let listHeight = listProxy.size.height
        let listStart = listProxy.frame(in: .global).minY
        let itemStart = itemProxy.frame(in: .global).minY

        let itemPercent =  (itemStart - listStart) / listHeight * 100

        return itemPercent
    }


    // MARK: Project 18 - Challenge 2: Change project 5 (Word Scramble) so that words towards the bottom of the list slide in from the right as you scroll. Ideally at least the top 8-10 words should all be positioned normally, but after that they should be offset increasingly to the right.
    func getOffset(listProxy: GeometryProxy, itemProxy: GeometryProxy) -> CGFloat {
        let listHeight = listProxy.size.height
        let listStart = listProxy.frame(in: .global).minY
        let itemStart = itemProxy.frame(in: .global).minY

        let itemPercent =  (itemStart - listStart) / listHeight * 100

        let thresholdPercent: CGFloat = 60
        let indent: CGFloat = 9

        if itemPercent > thresholdPercent {
            return (itemPercent - (thresholdPercent - 1)) * indent
        }

        return 0
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
        MainView()

        // MARK: Accessibility View
       // AccessibilityView()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
