//
//  ContentView.swift
//  FlashZilla
//
//  Created by Robert Shrestha on 11/16/20.
//

import SwiftUI
import CoreHaptics

// MARK: - Section 1: How to use gestures in SwiftUI
struct SectionOne: View {

    /*
    @State private var currentAmount: CGFloat = 0
    @State private var finalAmount: CGFloat = 1
    */

    /*
    @State private var currentAmount: Angle = .degrees(0)
    @State private var finalAmount: Angle = .degrees(0)
    */
    @State private var offset = CGSize.zero
    @State private var isDragging = false

    var body: some View {
/*
        Text("Hello world")
//            .onTapGesture(count: 2, perform: {
//                print("Doouble Tapped")
//            })

            /*
            .onLongPressGesture {
                print("Long Pressed")
            }
            */

            /*
            .onLongPressGesture(minimumDuration: 1, pressing: { inProgress in
                print("In progress: \(inProgress)!")
            }) {
                print("Long Pressed")
            }
            */

            /*
            .scaleEffect(finalAmount + currentAmount)
            .gesture(
                MagnificationGesture()
                    .onChanged({ (amount) in
                        self.currentAmount = amount - 1
                    })
                    .onEnded({ (amount) in
                        self.finalAmount += self.currentAmount
                        self.currentAmount = 0
                    })
            )
            */

            /*
            .rotationEffect(finalAmount + currentAmount)
            .gesture(
                RotationGesture()
                    .onChanged({ (angle) in
                        self.currentAmount = angle
                    })
                    .onEnded({ (angle) in
                        self.finalAmount += self.currentAmount
                        self.currentAmount = .degrees(0)
                    })
            )
            */
*/

        /*
        VStack {
            Text("Hello, World")
                .onTapGesture{
                    print("Text tapped")
                }
        }
        /*
         .onTapGesture{
         print("VStack tapped")
         }
         */
        /*
        .highPriorityGesture(
            TapGesture()
                .onEnded({ _ in
                    print("Vstack tapped")
                })
        )
        */
        .simultaneousGesture(
            TapGesture()
                .onEnded({
                    print("Vstack tapped")
                })
        )
        */

        let dragGesture = DragGesture()
            .onChanged { (value) in
                self.offset = value.translation
            }
            .onEnded{ _ in
                withAnimation{
                    self.offset = .zero
                    self.isDragging = false
                }
            }
        let pressureGesture = LongPressGesture()
            .onEnded { value in
                withAnimation{
                    self.isDragging = true
                }
            }
        let combined = pressureGesture.sequenced(before: dragGesture)

        return Circle()
            .fill(Color.red)
            .frame(width: 64, height: 64)
            .scaleEffect(isDragging ? 1.5 : 1)
            .offset(offset)
            .gesture(combined)


    }
}

// MARK: - Section 2: Making vibration with Core Haptics
struct SectionTwo: View {
    @State private var engine: CHHapticEngine?
    var body: some View {
        Text("Hello World")
            /*
            .onTapGesture(perform : simpleSuccess)
            */
            .onAppear(perform: prepeareHaptics)
            .onTapGesture(perform: {
                complexSuccess()
            })

    }
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    func prepeareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    func complexSuccess() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        /*
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity,sharpness], relativeTime: 0)
        */
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }

        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
            events.append(event)
        }
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription)")
        }
    }
}

// MARK: -  Disabling user interactivity with allowsHitTesting()
struct SectionThree: View {
    var body: some View {
        /*
        ZStack {
            Rectangle()
                .fill(Color.blue)
                .frame(width: 300, height: 300)
                .onTapGesture {
                    print("Rectangle Tapped")
                }
            Circle()
                .fill(Color.red)
                .frame(width: 300, height:300)
                .contentShape(Rectangle())
                .onTapGesture {
                    print("Circle Tapped")
                }
                .allowsHitTesting(false)
        }
        */

        VStack {
            Text("Hello")
            Spacer().frame(height: 100)
            Text("World")
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: {
            print("Vstack Tapped!")
        })

    }
}
// MARK: - Section 4: Triggering events repeatedly using a timer
struct SectionFour: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var  counter = 0
    var body: some View {
        Text("Hello World")
            .onReceive(timer, perform: { time in
                if self.counter == 5 {
                    self.timer.upstream.connect().cancel()
                } else {
                    print("The time is now \(time)")
                }
                self.counter += 1
            })
    }
}
// MARK: - Section 5: How to be notified when your SwiftUI app moves to the background
struct SectionFive: View {
    var body: some View {
        Text("Hello World")
            /*
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: { _ in
                print("Moving to the background")
            })
            */
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.userDidTakeScreenshotNotification), perform: { _ in
                print("User took a screenshot")
            })
    }
}
// MARK: - Section 6 : Supporting specific accessibility needs with SwiftUI

func withOptionalAnimation<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
    if UIAccessibility.isReduceMotionEnabled {
        return try body()
    } else {
        return try withAnimation(animation, body)
    }
}
struct SectionSix: View {
    //@Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    /*
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var scale: CGFloat = 1
    */
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    var body: some View {
        /*
        HStack {
            if differentiateWithoutColor {
                Image(systemName: "checkmark.circle")
            }
            Text("Success")
        }
        .padding()
        .background(differentiateWithoutColor ? Color.black : Color.green)
        .foregroundColor(Color.white)
        .clipShape(Capsule())
        */

        /*
        Text("Hello World")
            .scaleEffect(scale)
            .onTapGesture{
                if self.reduceMotion {
                    self.scale *= 1.5
                } else {
                    withAnimation{
                        self.scale *= 1.5
                    }
                }
            }
        */
        /*
        Text("Hello World")
            .scaleEffect(scale)
            .onTapGesture{
                withOptionalAnimation{
                    self.scale *= 1.5
                }
            }
        */
        Text("Hello World")
            .padding()
            .background(reduceTransparency ? Color.black : Color.black.opacity(0.5))
            .foregroundColor(Color.white)
            .clipShape(Circle())
    }
}
// MARK: Section 8: Building a stack of cards
extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = CGFloat(total - position)
        return self.offset(CGSize(width: 0, height: offset * 10))
    }
}
struct MainView: View {
    // MARK: Section 10: Coloring views as we swipe
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor

    // MARK: Section 14: Fixing the bugs
    @Environment(\.accessibilityEnabled) var accessibilityEnabled

    // MARK: Section 8: Building a stack of cards
    //@State private var cards = [Card](repeating: Card.example, count: 10)

    // MARK: Section 15: Adding and deleting cards
    @State private var cards = [Card]()

    // MARK: Section 11: Counting down with a Timer
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var isActive = true

    // MARK: Section 15: Adding and deleting cards
    @State private var isShowingEditView = false


    // MARK: Challange 1: Make something interesting for when the timer runs out. At the very least make some text appear, but you should also try designing a custom haptic using Core Haptics.
    @State private var engine: CHHapticEngine?

    // MARK: Challange 2: Add a settings screen that has a single option: when you get an answer one wrong that card goes back into the array so the user can try it again.
    @State private var dontRemoveCard: Bool = false
    @State private var isShowSettingView: Bool = false

    var body: some View {
        // MARK: Section 7: Designing a single card view
        //CardView(card: Card.example)

        // MARK: Section 8: Building a stack of cards
        ZStack {
            //Image("background")

            // MARK: Section 14: Fixing the bugs
            Image(decorative: "background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack {
                // MARK: Section 11: Counting down with a Timer
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(Color.black)
                            .opacity(0.75)
                    )
                ZStack {
                    ForEach(0 ..< cards.count, id: \.self) { index in

                        // MARK: Section 9: Moving views with DragGesture and offset()
                        CardView(card: self.cards[index]) { isCorrect in
                            withAnimation {
                                if isCorrect {
                                    self.remove(at: index)
                                } else {
                                    if self.dontRemoveCard {
                                        self.moveCard(at: index)
                                    } else {
                                        self.remove(at: index)
                                    }
                                }

                            }
                        }
                        .stacked(at: index, in: self.cards.count)

                        // MARK: Section 14: Fixing the bugs
                        .allowsHitTesting(index == self.cards.count - 1 || !(self.timeRemaining <= 0 ))
                        .accessibilityHidden(index < self.cards.count - 1)
                    }
                }
                // MARK: Section 12: Ending the app with allowsHitTesting()
                .allowsHitTesting(timeRemaining > 0)
                // MARK: Challange 1: Make something interesting for when the timer runs out. At the very least make some text appear, but you should also try designing a custom haptic using Core Haptics.
                if timeRemaining <= 0 {
                    Text("You run out of time.You can start again")
                        .font(.title)
                        .padding()
                }
                if cards.isEmpty || timeRemaining <= 0{
                    Button("Start Again", action: resetCard)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }

            // MARK: Section 15: Adding and deleting cards
            VStack {
                HStack {
                    Button(action: {
                        self.isShowSettingView = true
                    }, label: {
                        Image(systemName: "gear")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    })
                    Spacer()
                    Button(action: {
                        self.isShowingEditView = true
                    }, label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    })
                }
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()


            // MARK: Section 10: Coloring views as we swipe
            if differentiateWithoutColor || accessibilityEnabled {
                VStack {
                    Spacer()

                    HStack {
                        // MARK: Section 14: Fixing the bugs
                        Button(action: {
                            withAnimation{
                                if self.dontRemoveCard {
                                    self.moveCard(at: self.cards.count - 1)
                                } else {
                                    self.remove(at: self.cards.count - 1)
                                }
                            }
                        }) {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Wrong"))
                        .accessibility(hint: Text("Mark your answer as being incorrect."))
                        Spacer()

                        // MARK: Section 14: Fixing the bugs
                        Button(action: {
                            withAnimation {
                                self.remove(at: self.cards.count - 1)
                            }
                        }) {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Correct"))
                        .accessibility(hint: Text(" Mark your answer as being correct. "))
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }

            }
       }
        // MARK: Section 11: Counting down with a Timer
        .onReceive(timer) { time in
            guard self.isActive else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
            // MARK: Challange 1: Make something interesting for when the timer runs out. At the very least make some text appear, but you should also try designing a custom haptic using Core Haptics.
            else if self.timeRemaining == 0 {
                self.cards.removeAll()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: { _ in
            self.isActive = false
        })
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification), perform: { _ in
            // MARK: Section 12: Ending the app with allowsHitTesting()
            if self.cards.isEmpty {
                isActive = false
            }
            self.isActive = true
        })
        // MARK: Challange 2: Add a settings screen that has a single option: when you get an answer one wrong that card goes back into the array so the user can try it again.
        .background(EmptyView().sheet(isPresented: $isShowSettingView,onDismiss: resetCard, content: {
            SettingView(dontRemoveCard: $dontRemoveCard)
        }))

        // MARK: Section 15: Adding and deleting cards
        .background(EmptyView().sheet(isPresented: $isShowingEditView, onDismiss: resetCard, content: {
            EditCard()
        }))

        .onAppear(perform: {
            resetCard()
        })

    }
    // MARK: Section 9: Moving views with DragGesture and offset()
    func remove(at index: Int) {
        guard index >= 0 else { return  }
        self.cards.remove(at: index)
        if cards.isEmpty {
            isActive = false
        }
    }

    // MARK: Challange 2: Add a settings screen that has a single option: when you get an answer one wrong that card goes back into the array so the user can try it again.

    func moveCard(at index: Int) {
        guard index >= 0 else { return  }
        let wrongCard = cards.remove(at: index)
        cards.insert(wrongCard, at: 0)
        if cards.isEmpty {
            isActive = false
        }
    }

    // MARK: Section 12: Ending the app with allowsHitTesting()
    func resetCard() {
       // cards = [Card](repeating: Card.example, count: 10)
        timeRemaining = 100
        isActive = true
        // MARK: Section 15: Adding and deleting cards
        loadData()
        
        // MARK: Challange 1: Make something interesting for when the timer runs out. At the very least make some text appear, but you should also try designing a custom haptic using Core Haptics.
        prepeareHaptics()
    }

    // MARK: Section 15: Adding and deleting cards
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                self.cards = decoded
            }
        }
    }

// MARK: Challange 1: Make something interesting for when the timer runs out. At the very least make some text appear, but you should also try designing a custom haptic using Core Haptics.
    func prepeareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    func complexSuccess() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        /*
         let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
         let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
         let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity,sharpness], relativeTime: 0)
         */
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }

        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
            events.append(event)
        }
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription)")
        }
    }

    
}
struct ContentView: View {
    var body: some View {
        // MARK: Section 1: How to use gestures in SwiftUI
       // SectionOne()

        // MARK: Section 2: Making vibrations with Core Haptics
        //SectionTwo()

        // MARK: Section 3: Disabling user interactivity with allowsHitTesting()
        //SectionThree()

        // MARK: Section 4: Triggering events repeatedly using a timer
        //SectionFour()

        // MARK: Section 5: How to be notified when your SwiftUI app moves to the background
        //SectionFive()

        // MARK: Section 6: Supporting specific accessibility needs with SwiftUI
        //SectionSix()

        // MARK: Section 7: Designing a single card view
        MainView()

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
