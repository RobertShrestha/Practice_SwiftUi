//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Robert Shrestha on 6/30/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI


// MARK:  Challenge of section View and modifier
struct FlagImage: View {
    var name: String
    var body: some View {
        Image(name)
            .renderingMode(.original)
            .clipShape(Capsule()).overlay(Capsule().stroke(Color.black,lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}
// MARK: Section 1
struct StackView: View {
    var body: some View {
         HStack(alignment: .center, spacing:  20){
             Text("Hello World")
             Text("Hello not this again")
         }
        /*
         VStack(alignment: .leading, spacing: 20){
         Text("Hello World")
         Text("Hello not this again")
         }
         */
    }
}
// MARK: Section 2
struct ColorFrameView: View {
    var body: some View {
        ZStack {
            // Color.red.frame(width: 200, height: 200)
            Color.red.edgesIgnoringSafeArea(.all)
            //Color(red: 1, green: 0.8, blue: 0)
            Text("Your content")
        }
        //.background(Color.red)
    }
}
// MARK: Section 3
struct GradientView: View {
    var body: some View {
        //LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .top, endPoint: .bottom)
        //RadialGradient(gradient: Gradient(colors: [.white, .black]), center: .center, startRadius: 20, endRadius: 200)
        AngularGradient(gradient: Gradient(colors: [.red,.yellow,.green,.blue,.purple,.red]), center: .center)
    }
}
// MARK: Section 4
struct ButtonImageView: View {
    var body: some View {
         //        Button("Tap me") {
         //            print("Button was tapped")
         //        }
            Button(action: {
                print("tapped")
            }) {
                HStack(spacing: 20) {
                    Image(systemName: "pencil")
                    Text("Edit")
                }.background(Color.blue)
                    .foregroundColor(.white)
        }

    }
}

// MARK: Section 5
struct CustomAlertView: View {
     @State private var showingAlert = false
    var body: some View {
        //        Alert(title: Text("Hello SwiftUI"), message: Text("It working awesome"), dismissButton: .default(Text("Ok")))
         Button("Show Alert") {
         self.showingAlert = true
         }.alert(isPresented: $showingAlert) {
         Alert(title: Text("Hello SwiftUI"), message: Text("It working awesome"), dismissButton: .default(Text("Ok")))
         }
    }
}

struct AccesssibilityView: View {

    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    @State private var countries = ["Estonia","France","Germany","Ireland","Italy","Nigeria","Poland","Russia","Spain","UK","US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)

    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    var body: some View {
        ZStack {
            //Color.blue.edgesIgnoringSafeArea(.all)
            LinearGradient(gradient: Gradient(colors: [.blue,.black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                    Text("\(countries[correctAnswer])")
                        .font(.largeTitle)
                        .fontWeight(.black)
                }.foregroundColor(.white)
                ForEach(0 ..< 3) { number in
                    Button(action:{
                        print("Tapped")
                        self.flagTapped(number)
                    }) {
                        Image(self.countries[number])
                            .renderingMode(.original)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                        .shadow(color: .black, radius: 2)
                        .accessibility(label: Text(self.labels[self.countries[number], default: "Unknown flag"]))
                       // FlagImage(name: self.countries[number])
                    }
                }
                Spacer()
            }
        }.alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"), dismissButton: .default(Text("Countinue")){
                self.askQuestion()
                })
        }
    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong"
            score = 0
        }
        showingScore = true
    }
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct MainView: View {

    @State private var countries = ["Estonia","France","Germany","Ireland","Italy","Nigeria","Poland","Russia","Spain","UK","US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)

    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    var body: some View {
        ZStack {
            //Color.blue.edgesIgnoringSafeArea(.all)
            LinearGradient(gradient: Gradient(colors: [.blue,.black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                    Text("\(countries[correctAnswer])")
                        .font(.largeTitle)
                        .fontWeight(.black)
                }.foregroundColor(.white)
                ForEach(0 ..< 3) { number in
                    Button(action:{
                        print("Tapped")
                        self.flagTapped(number)
                    }) {
                        //                        Image(self.countries[number])
                        //                            .renderingMode(.original)
                        //                        .clipShape(Capsule())
                        //                        .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                        //                        .shadow(color: .black, radius: 2)
                        FlagImage(name: self.countries[number])
                    }
                }
                Spacer()
            }
        }.alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"), dismissButton: .default(Text("Countinue")){
                self.askQuestion()
                })
        }

    }

    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong"
            score = 0
        }
        showingScore = true
    }
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView: View {


    var body: some View {
       // Text("Hello world")

        // MARK: Section 1: Using stacks to arrange views
       // StackView()

        // MARK: Section 2: Colors and frames
       // ColorFrameView()

         // MARK: Section 3: Gradients
        //GradientView()

        // MARK:  Section 4: Buttons and images
        //ButtonImageView()

        // MARK: Section 5: Showing alert messages
       // CustomAlertView()

        // MARK: Main View
        //MainView()

        // MARK: Accessibility view
        AccesssibilityView()

    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
