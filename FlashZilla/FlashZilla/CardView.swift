//
//  CardView.swift
//  FlashZilla
//
//  Created by Robert Shrestha on 11/16/20.
//

import SwiftUI
// MARK: Section 7: Designing a single card view
struct CardView: View {
    // MARK: Section 10: Coloring views as we swipe
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentIateWithoutColor

    // MARK: Section 14: Fixing the bugs
    @Environment(\.accessibilityEnabled) var accessibilityEnabled

    var card: Card
    @State private var isShowingAnswer = false

    // MARK: Section 9: Moving views with DragGesture and offset()
    @State private var offset = CGSize.zero
    var removal: ((_ correct:Bool) -> Void)? = nil

    // MARK: Section 13: Making iPhones vibrate with UINotificationFeedbackGenerator
    @State private var feedback = UINotificationFeedbackGenerator()
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                //.fill(Color.white)
            // MARK: Section 10: Coloring views as we swipe
                .fill(
                    differentIateWithoutColor ?
                        Color.white
                        : Color.white
                            .opacity(1 - Double(abs(offset.width / 50)))
                )


                /*
                .background(
                    differentIateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 20,style: .continuous)
                            .fill(offset.width > 0 ? Color.green : Color.red)
                )
                */
                // MARK: Challange 3:If you drag a card to the right but not far enough to remove it, then release, you see it turn red as it slides back to the center. Why does this happen and how can you fix it? (Tip: use a custom modifier for this to avoid cluttering your body property.)
                .modifier(CardBackgroundColor(differentiateColor: differentIateWithoutColor, offset: offset))
                .shadow(radius: 10)
            VStack {
                if accessibilityEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                } else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)

        // MARK: Section 9: Moving views with DragGesture and offset()
        .rotationEffect(.degrees(Double(offset.width / 5 )))
        .offset(x: offset.width * 5, y: 0)
        .opacity(2 - Double(abs(offset.width / 50 )))

        // MARK: Section 14: Fixing the bugs
        .accessibilityAddTraits(.isButton)

        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation

                    // MARK: Section 13: Making iPhones vibrate with UINotificationFeedbackGenerator
                    self.feedback.prepare()
                }
                .onEnded { _ in
                    if abs(self.offset.width) > 100 {

                        // MARK: Section 13: Making iPhones vibrate with UINotificationFeedbackGenerator
                        if self.offset.width > 0 {
                            self.feedback.notificationOccurred(.success)
                            self.removal?(true)
                        } else {
                            self.feedback.notificationOccurred(.error)
                            self.removal?(false)
                        }
                    } else {
                        self.offset = .zero
                    }
                }
        )

        .onTapGesture {
            self.isShowingAnswer.toggle()
        }
        // MARK: Section 14: Fixing the bugs
        .animation(.spring())
    }
}
// MARK: Challange 3:If you drag a card to the right but not far enough to remove it, then release, you see it turn red as it slides back to the center. Why does this happen and how can you fix it? (Tip: use a custom modifier for this to avoid cluttering your body property.)
struct CardBackgroundColor: ViewModifier {
    let differentiateColor: Bool
    let offset: CGSize
    var backgroundColor: Color {
        if offset.width > 0 {
            return .green
        } else if offset.width == 0 {
            return .white
        } else {
            return .red
        }
    }
    func body(content: Content) -> some View {
        content
            .background(
                differentiateColor
                ? nil
                    : RoundedRectangle(cornerRadius: 20,style: .continuous)
                    .fill(backgroundColor)
            )
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example     )
    }
}
