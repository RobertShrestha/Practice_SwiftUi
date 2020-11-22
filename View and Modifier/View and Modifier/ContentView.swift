//
//  ContentView.swift
//  View and Modifier
//
//  Created by Robert Shrestha on 8/1/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI

// MARK: Section 1
struct LayoutView: View {
    var body: some View {
        Text("Hello, World!")
            .frame(maxWidth: .infinity, maxHeight:  .infinity)
            .background(Color.red)
            .edgesIgnoringSafeArea(.all)
    }
}


// MARK: Section 2
struct StructView: View {
    var body: some View {
        Button("Hello World") {

        }
        .frame(width: 300, height: 300, alignment: .center)
        .background(Color.red)
        // .frame(width: 300, height: 300, alignment: .center)

//        Text("Hello World")
//            .padding()
//            .background(Color.red)
//            .padding()
//            .background(Color.blue)
//            .padding()
//            .background(Color.yellow)
    }
}
// MARK: Section 3
struct ModifierOrderView: View {
    var body: some View {
        Button("Hello World") {

        }
        .frame(width: 300, height: 300, alignment: .center)
        .background(Color.red)
        // .frame(width: 300, height: 300, alignment: .center)
    }
}

// MARK: Section 5
struct ConditionerModifierView: View {
    @State private var useRedText = false
    var body: some View {
        Button("Hello World"){
            self.useRedText.toggle()
        }
        .foregroundColor(useRedText ? .red : .blue)
    }
}
// MARK: Section 6
struct EnviromentModifierView: View {
    var body: some View {
        VStack {
             Text("Ram")
                .font(.largeTitle) //Single modifier to single text
                .blur(radius: 0)
             Text("Ram")
             Text("Ram")
             Text("Ram")
             Text("Ram")
        }
        .blur(radius: 8)
        .font(.title) // Enviroment Modifier
    }
}
// MARK: Section 7
struct PropertiesView: View {
    let name1 = Text("Robert")
    let name2 = Text("Ram")
    var body: some View {
        VStack {
            name1
                .foregroundColor(Color.blue)
            name2.foregroundColor(Color.red)
        }
    }
}
// MARK: Section 8
struct CapsuleText: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .padding()
            //.foregroundColor(.white)
            .background(Color.blue)
            .clipShape(Capsule())
    }
}

struct CompositionView: View {
    var body: some View {
        VStack (spacing:20){
            CapsuleText(text: "First")
                .foregroundColor(.white)
            CapsuleText(text: "Second")
                .foregroundColor(.yellow)
        }
    }
}

// MARK: Section 9

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
extension View { // Can extend also Text
    func titleStyle() -> some View {
        self.modifier(Title())
    }
}
struct Watermark: ViewModifier {
    var text: String
    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            Text(text)
                .foregroundColor(.white)
                .font(.caption)
                .padding(5)
                .background(Color.black)
        }
    }
}

extension View {
    func watermarked(with text: String) -> some View {
        self.modifier(Watermark(text: text))
    }
}
struct CustomModifier: View {
    var body: some View {
            Text("Hello World")
            .titleStyle()

            /*
            Color.blue
                .frame(width: 300, height: 300, alignment: .center)
            .watermarked(with: "Robert")
            */
    }
}

// MARK: Section 10
struct CustomContainerView: View {
    var body: some View {
        GridStack(rows: 3, columns: 3) { row, col in
            // HStack { Used ViewModifier so its not needed now
            Image(systemName: "\(row * 3 + col).circle")
            Text("R\(row) C\(col)")
            // }

        }
    }
}

struct GridStack<Content: View>: View {

    let rows: Int
    let columns: Int
    let content: (Int,Int) -> Content

    var body: some View {
        // more to come
        VStack {
            ForEach(0 ..< rows) { row in
                HStack {
                    ForEach(0 ..< self.columns) { column in
                        self.content(row,column)
                    }
                }
            }
        }
    }
    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int,Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }

}

struct ContentView: View {
    var body: some View {
        // MARK: Section 1: Layout of swiftUi
        //LayoutView()

        // MARK: Section 2: The view is redrawn everytime you add a modifier not update so frame at the last does not work.

        //StructView()

        // MARK: Section 3: Why modifier order matters
        //ModifierOrderView()

        // MARK: Section 4 : View is treated as Tuple so you cannot have more than 10

        // MARK:  Section 5: Conditional modifier

        //ConditionerModifierView()


        // MARK: Section 6: Enviroment Modifier
        // Regular Modifier(RM) vs Enviroment Modifier(EM)
        // Blur is RM so it does not override the modifier
        // Font is EM so it overrides the modifier
        // Cannot know which is regular or enviroment modifier

        // EnviromentModifierView()

        // MARK: Section 7 : View as Propertise
        //PropertiesView()
        // MARK: Section 8: View Composition
        //CompositionView()

        // MARK: Section 9: Custom Modifier
       // CustomModifier()

        // MARK:  Section 10: Custom Container
        CustomContainerView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
