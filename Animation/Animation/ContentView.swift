//
//  ContentView.swift
//  Animation
//
//  Created by Robert Shrestha on 8/5/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI
// MARK: Section 1
struct ImplicitAnimationView: View {
    @State private var animationAmount: CGFloat = 1
    var body: some View {
        Button("Tap me") {
            self.animationAmount += 1
        }
        .padding(50)
        .background(Color.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        .scaleEffect(animationAmount)
            //.blur(radius: (animationAmount - 1) * 3)
            .animation(.default)
    }
}

// MARK: Section 2
struct CustomAnimationView: View {
    @State private var animationAmount: CGFloat = 1
    var body: some View {
        Button("Tap me") {
            //            self.animationAmount += 1
        }
        .padding(50)
        .background(Color.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(Color.red)
                .scaleEffect(animationAmount)
                .opacity(Double(2 - animationAmount))
                .animation(
                    Animation.easeInOut(duration: 1)
                        .repeatForever(autoreverses: false)
            )

        )
            /*
            .scaleEffect(animationAmount)
            .animation(.easeOut)
            .animation(.interpolatingSpring(stiffness: 50, damping: 2))
                        .animation(
                            //Animation.easeInOut(duration: 2)
                            //.delay(1)
                            Animation.easeInOut(duration: 1)
                                //.repeatCount(3, autoreverses: true)
                                .repeatForever(autoreverses: true)
                    )
            */
            .onAppear {
                self.animationAmount = 2
        }
    }
}
// MARK: Section 3
struct AnimationBindingView: View {
   @State private var animationAmount: CGFloat = 1
    var body: some View {
        print(animationAmount)
        return VStack {
            Stepper("Scale amount", value: $animationAmount.animation(
                Animation.easeInOut(duration: 1)
                    .repeatCount(3, autoreverses: true)
            ), in: 1...10)
            Spacer()
            Button("Tap me") {
                self.animationAmount += 1
            }
            .padding(50)
            .background(Color.red)
            .foregroundColor(Color.white)
            .clipShape(Circle())
            .scaleEffect(animationAmount)

        }
    }
}
// MARK: Section 4
struct ExplicityAnimationView: View {
     @State private var animationAmount = 0.0
    var body: some View {
                Button("Tap me") {
                    withAnimation(
        //                Animation.easeInOut(duration: 2)
        //                .repeatCount(3, autoreverses: true)
                        .interpolatingSpring(stiffness: 50, damping: 1)
                        )
                    {
                        self.animationAmount += 360
                    }
                }.padding(50)
                    .foregroundColor(.white)
                    .background(Color.red)
                    .clipShape(Circle())
                    .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
    }
}
// MARK: Section 5
struct AnimationStack: View {
    @State private var enable = false
    var body: some View {
        Button("Tap me "){
            self.enable.toggle()
        }
        .frame(width: 200, height: 200)
        .foregroundColor(.white)
        .background(enable ? Color.red : Color.blue)
        .animation(.default)
 //       .animation(nil) // Remove animation
        .clipShape(RoundedRectangle(cornerRadius: enable ? 60 : 0))
        .animation(.interpolatingSpring(stiffness: 50, damping: 1))
    }
}
// MARK: Section 6
struct AnimationGestureView: View {
    @State private var dragAmount = CGSize.zero
    let letters = Array("Hello SwiftUI")
    @State private var enable = false
    var body: some View {
        /*
        LinearGradient(gradient: Gradient(colors: [.yellow,.red]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(width: 300, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .offset(dragAmount)
            .gesture(
                DragGesture()
                    .onChanged { self.dragAmount = $0.translation}
                    .onEnded { _ in
                        withAnimation(.spring()){
                            self.dragAmount = .zero}
                }
        )
        //     .animation(.spring())
        */

        HStack(spacing: 0) {
            ForEach(0..<letters.count) { num in
                Text(String(self.letters[num]))
                    .padding(5)
                    .font(.title)
                    .background(self.enable ? Color.blue : Color.red)
                    .offset(self.dragAmount)
                    .animation(Animation.default.delay(Double(num) / 20))
            }
        }
        .gesture(
            DragGesture()
                .onChanged{ self.dragAmount = $0.translation }
                .onEnded{ _ in
                    self.dragAmount = .zero
                    self.enable.toggle()
            }
        )

    }
}

// MARK: Section 7
struct ShowHideView: View {
     @State private var isShowingRed = false
    var body: some View {
        VStack {
            Button("Tap me") {
                withAnimation{
                    self.isShowingRed.toggle()
                }
            }
            if isShowingRed {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 300, height: 300)
                    //.transition(.scale)
                    //.transition(.asymmetric(insertion: .scale, removal: .opacity))
                    .transition(.pivot)
            }

        }
    }
}


// MARK: Section 8
struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(amount), anchor: anchor)
        .clipped()
    }
}
extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}
struct ContentView: View {
    var body: some View {

        // MARK: Section 1 : Creating implicit animations
        ImplicitAnimationView()

        // MARK: Section 2: Customizing animations
        //CustomAnimationView()

        // MARK: Section 3 : Animation Binding
        //AnimationBindingView()

        // MARK: Section 4: Creating Explicity Animation
        //ExplicityAnimationView()

        // MARK: Section 5: Controlling the animation stack
        //AnimationStack()


        // MARK: Section 6 : Animating gestures
        //AnimationGestureView()

        // MARK: Section 7 : Showing and hiding views with transitions
        //ShowHideView()
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
