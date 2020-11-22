//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by Robert Shrestha on 11/19/20.
//

import SwiftUI

// MARK: - Section 1: How layout works in SwiftUI
struct SectionOne: View {
    var body: some View {
        Text("Hello World")
            .background(Color.red)
            .padding(20)
    }
}
// MARK: - Section 2: Alignment and alignment guides
struct SectionTwo: View {
    var body: some View {
        /*
        Text("Live long and prosper")
            .frame(width: 300, height: 300, alignment: .topLeading)
        */
        /*
        HStack(alignment: .lastTextBaseline) {
            Text("Live")
                .font(.caption)
            Text("long")
            Text("and")
                .font(.title)
            Text("prosper")
                .font(.largeTitle)
        }
        */

        /*
        VStack(alignment: .leading) {
            Text("Hello world")
                .alignmentGuide(.leading, computeValue: { dimension in
                    dimension[.trailing]
                })
                Text("This is a long line of text")
        }
        .background(Color.red)
        .frame(width: 400, height: 400)
        .background(Color.blue)
        */
        VStack(alignment: .leading) {
            ForEach(0..<10) { position in
                Text("Number \(position)")
                    .alignmentGuide(.leading, computeValue: { dimension in
                        CGFloat(position) * -10
                    })
            }
        }
        .background(Color.red)
        .frame(width: 400, height: 400)
        .background(Color.blue)

    }
}
// MARK: - Section 3: How to create a custom alignment guide
extension VerticalAlignment {
    enum MidAccountAndName: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.top]
        }
    }
    static let midAccountAndName = VerticalAlignment(MidAccountAndName.self)
}
struct SectionThree: View {
    var body: some View {
        HStack(alignment: .midAccountAndName){
            VStack {
                Text("@RobertShrestha")
                    .alignmentGuide(.midAccountAndName, computeValue: { dimension in
                        dimension[VerticalAlignment.center]
                    })
                Image(systemName: "gear")
                    .resizable()
                    .frame(width: 64, height: 64)
            }
            VStack {
                Text("Full name:")
                Text("Robert Shrestha")
                    .alignmentGuide(.midAccountAndName, computeValue: { dimension in
                        dimension[VerticalAlignment.center]
                    })
                    .font(.largeTitle)
            }
        }
    }
}

// MARK: - Section 4: Absolute positioning for SwiftUI views
struct SectionFour: View {
    var body: some View {
        Text("Hello world")
            /*
            .background(Color.red)
            .position(x: 100, y: 100)
            */
            .background(Color.red)
            .offset(x: 100, y: 100)
    }
}
// MARK: - Section 5: Understanding frames and coordinates
struct OuterView: View {
    var body: some View{
        VStack {
            Text("Top")
            InnerView()
                .background(Color.green)
            Text("Bottom")
        }
    }
}
struct InnerView: View {
    var body: some View {
        HStack {
            Text("Left")
            GeometryReader { geo in
                VStack {
                Text("Center")
                    .background(Color.blue)
                    .onTapGesture {
                        print("Global center: \(geo.frame(in: .global).midX) x \(geo.frame(in: .global).midY)")
                        print("Custom center: \(geo.frame(in: .named("Custom")).midX) x \(geo.frame(in: .named("Custom")).midY)")
                        print("Local center: \(geo.frame(in: .local).midX) x \(geo.frame(in: .local).midY)")
                    }
                }
                .position(x:geo.frame(in:.local).midX,y:geo.frame(in:.local).midY)
            }
            .background(Color.orange)
            Text("Right")
        }
    }
}
struct SectionFive: View {
    var body: some View {
        /*
        VStack {
            GeometryReader { geo in
                VStack {
                    Text("Hello, World!")
                        .frame(width: geo.size.width * 0.9, height: 40)
                        .background(Color.red)
                }
            .position(x:geo.frame(in:.local).midX,y:geo.frame(in:.local).midY)
            }
            .background(Color.green)
            Text("More text")
                .background(Color.blue)
        }
        */
        OuterView()
            .background(Color.red)
            .coordinateSpace(name: "Custom")

    }
}
// MARK: - Section 6: ScrollView effects using GeometryReader
struct SectionSix: View {
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]
    var body: some View {
        /*
        GeometryReader { fullView in
            ScrollView(.vertical) {
                ForEach(0..<50) { index in
                    GeometryReader { geo in
                    Text("Row #\(index)")
                        .font(.title)
                        .frame(width: fullView.size.width)
                        .background(self.colors[index % 7])
                        .rotation3DEffect(
                            .degrees(Double(geo.frame(in: .global).minY - fullView.size.height / 2) / 5),
                            axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                }
                .frame(height: 40)
            }
            }
        }
        */
        GeometryReader { fullView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<50) { index in
                        GeometryReader { geo in
                            Rectangle()
                                .fill(self.colors[index % 7 ])
                                .frame(height: 150)
                                .rotation3DEffect(
                                    .degrees(-Double(geo.frame(in: .global).minX - fullView.size.width / 2) / 10),
                                    axis: (x: 0.0, y: 1.0, z: 0.0))
                                .position(x:geo.frame(in:.local).midX,
                                          y:geo.frame(in:.local).midY)

                        }

                        .frame(width: 150)

                    }

                }

                .padding(.horizontal, (fullView.size.width - 150) / 2)
            }

            //.edgesIgnoringSafeArea(.all)
        }

    }
}
struct ContentView: View {
    var body: some View {
        // MARK: Section 1: How layout works in SwiftUI
       // SectionOne()

        // MARK: Section 2: Alignment and alignment guides
        //SectionTwo()

        // MARK: Section 3: How to create a custom alignment guide
        //SectionThree()

        // MARK: Section 4: Absolute positioning for SwiftUI views
        //SectionFour()

        // MARK: - Section 5: Understanding frames and coordinates
        //SectionFive()

        // MARK: Section 6: ScrollView effects using GeometryReader
         SectionSix()

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
