//
//  ContentView.swift
//  Drawing
//
//  Created by Robert Shrestha on 8/13/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI

// MARK: Section 1:

struct PathView: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 200, y: 100))
            path.addLine(to: CGPoint(x: 100, y: 300))
            path.addLine(to: CGPoint(x: 300, y: 300))
            path.addLine(to: CGPoint(x: 200, y: 100))
        }
            // .fill(Color.blue)
            //  .stroke(Color.blue,lineWidth: 10)
            .stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round) )
    }
}
// MARK: Section 2: Paths vs Shapes
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x:rect.midX,y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}
struct Arc: InsettableShape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    var insetAmount: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width/2 - insetAmount, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)
        return path
    }
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}

struct PathsShapesView: View {
    var body: some View {
        /*
         Triangle()
         //.fill(Color.blue)
         .stroke(Color.blue.opacity(0.5),style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
         .frame(width: 300, height: 300)
         */
        Arc(startAngle: .degrees(0), endAngle: .degrees(100), clockwise: true)
            .stroke(Color.blue.opacity(0.5),style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
            .frame(width: 300, height: 300)
    }
}

// MARK: Section 3
struct InsettableView: View {
    var body: some View {
        /*
         Circle()
         // .stroke(Color.blue,lineWidth: 30)
         .strokeBorder(Color.blue, lineWidth: 30)
         */
        Arc(startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: true)
            .strokeBorder(Color.blue, lineWidth: 30)
    }
}

// MARK: Section 4
struct Flower: Shape {
    var petalOffet: Double = -20
    var petalWidth: Double = 100

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for number in stride(from: 0, to: CGFloat.pi * 2, by: CGFloat.pi / 10) {
            let rotation = CGAffineTransform(rotationAngle: number)
            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width/2, y: rect.height/2))
            let originalPetal = Path(ellipseIn: CGRect(x: CGFloat(petalOffet), y: 0, width: CGFloat(petalWidth), height: rect.width/2))
            let rotatedPetal = originalPetal.applying(position)
            path.addPath(rotatedPetal)
        }
        return path
    }

}

struct OddEvenFillView: View {
    @State private var petalOffset: Double = -20
    @State private var petalWidth: Double = 100

    var body: some View {
        VStack {
            Flower(petalOffet: petalOffset, petalWidth: petalWidth)
                //.stroke(Color.red,lineWidth: 1)
                .fill(Color.red,style: FillStyle(eoFill: true))
            Text("Offset")
            Slider(value: $petalOffset,in: -40...40)
                .padding([.horizontal,.bottom])
            Text("Width")
            Slider(value: $petalWidth,in: 0...100)
                .padding([.horizontal])

        }
    }
}

// MARK: Section 5

struct ImagePaintView: View {
    var body: some View {
        /*
         Text("Hello World")
         .frame(width: 300, height: 300)
         //.background(Image("Example"))
         //.background(Color.red)
         //.border(Color.red,width: 30)
         //.border(ImagePaint(image: Image("Example"), scale: 0.2),width: 30)
         .border(ImagePaint(image: Image("Example"),sourceRect: CGRect(x: 0, y: 0.25, width: 1, height: 0.5), scale: 0.2),width: 30)
         */

        Capsule()
            .strokeBorder(ImagePaint(image: Image("Example"),scale: 0.1), lineWidth: 30)
            .frame(width: 300, height: 200)
    }
}

 // MARK: Section 6
struct ColorCyclingCircle: View {
    var amount = 0.0
    var steps = 100

    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Circle()
                    .inset(by:CGFloat(value))
//                    .strokeBorder(self.color(for: value, brightness: 1),lineWidth: 2)
                 .strokeBorder(LinearGradient(gradient: Gradient(colors: [
                    self.color(for: value, brightness: 1),
                    self.color(for: value, brightness: 0.5)
                 ]), startPoint: .top, endPoint: .bottom),lineWidth: 2)
            }
        }
    .drawingGroup() // solves the lagging issue while adding lineargradient
    }
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps)  + self.amount
        if targetHue > 1 {
            targetHue -= 1
        }
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}
struct DrawingGroupView: View {

    @State private var colorCycle = 0.0
    var body: some View {
        VStack {
            ColorCyclingCircle(amount: self.colorCycle)
                .frame(width: 300, height: 300)
            Slider(value: $colorCycle)
        }
    }
}

// MARK: Section 7

struct SpecialEffectView: View {

    @State private var amount: CGFloat = 0.0
    var body: some View {
        /*
        ZStack {
            Image("Example")

            Rectangle()
                .fill(Color.red)
                .blendMode(.multiply)
        }
        .frame(width:400, height: 500)
        .clipped()
        */

        /* // simple way of doing the same work as above
         Image("Example")
         .colorMultiply(.red)
         */
        VStack {
            /*
             ZStack {
             Circle()
             //.fill(Color.red)
             .fill(Color(red: 1, green: 0, blue: 0))
             .frame(width: 200 * amount)
             .offset(x: -50,y: -80)
             .blendMode(.screen)

             Circle()
             // .fill(Color.green)
             .fill(Color(red: 0, green: 1, blue: 0))
             .frame(width: 200 * amount)
             .offset(x: 50,y: -80)
             .blendMode(.screen)

             Circle()
             //.fill(Color.blue)
             .fill(Color(red: 0, green: 0, blue: 1))
             .frame(width: 200 * amount)
             .blendMode(.screen)
             }
             .frame(width:300, height: 300)
             */
            Image("Example")
                .resizable()
                .scaledToFit()
                .frame(width: 200,height: 200)
                .saturation(Double(amount))
                .blur(radius:(1 - amount) * 20)

            Slider(value:$amount)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

 // MARK: Section 8
struct Trapezoid: Shape {
    var insetAmount: CGFloat

    var animatableData: CGFloat {
        get { self.insetAmount}
        set {self.insetAmount = newValue}
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        return path
    }
}

struct TrapeziodView: View {
    @State private var insetAmount: CGFloat = 50
    var body: some View {
        Trapezoid(insetAmount: insetAmount)
            .frame(width: 200,height: 100)
            .onTapGesture {
                withAnimation{
                    self.insetAmount = CGFloat.random(in: 10...90)
                }

        }
    }
}
// MARK: Section 9
struct CheckerBoard: Shape {
    var rows: Int
    var columns: Int

    var animatableData: AnimatablePair<Double,Double> {
        get {
            AnimatablePair(Double(rows),Double(columns))
        }
        set {
            self.rows = Int(newValue.first)
            self.columns = Int(newValue.second)
        }
    }
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let rowSize = rect.height / CGFloat(rows)
        let columnSize = rect.width / CGFloat(columns)

        for row in 0..<rows{
            for column in 0..<columns {
                if (row + column).isMultiple(of: 2) {
                    let startX = columnSize * CGFloat(column)
                    let startY = rowSize * CGFloat(row)
                    let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
                    path.addRect(rect)
                }
            }
        }
        return path
    }
}

// MARK: Section 10
struct Spirograph: Shape {
    let innerRadius: Int
    let outerRadius: Int
    let distance: Int
    let amount: CGFloat

    func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b

        while b != 0 {
            let temp = b
            b = a % b
            a = temp
        }

        return a
    }

    func path(in rect: CGRect) -> Path {
        let divisor = gcd(innerRadius, outerRadius)
        let outerRadius = CGFloat(self.outerRadius)
        let innerRadius = CGFloat(self.innerRadius)
        let distance = CGFloat(self.distance)
        let difference = innerRadius - outerRadius
        let endPoint = ceil(2 * CGFloat.pi * outerRadius / CGFloat(divisor)) * amount

        var path = Path()

        for theta in stride(from: 0, through: endPoint, by: 0.01) {
            var x = difference * cos(theta) + distance * cos(difference / outerRadius * theta)
            var y = difference * sin(theta) - distance * sin(difference / outerRadius * theta)

            x += rect.width / 2
            y += rect.height / 2

            if theta == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        return path
    }
}

struct SpirographContentView: View {
    @State private var innerRadius = 125.0
    @State private var outerRadius = 75.0
    @State private var distance = 25.0
    @State private var amount: CGFloat = 1.0
    @State private var hue = 0.6

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Spirograph(innerRadius: Int(innerRadius), outerRadius: Int(outerRadius), distance: Int(distance), amount: amount)
                .stroke(Color(hue: hue, saturation: 1, brightness: 1), lineWidth: 1)
                .frame(width: 300, height: 300)

            Spacer()

            Group {
                Text("Inner radius: \(Int(innerRadius))")
                Slider(value: $innerRadius, in: 10...150, step: 1)
                    .padding([.horizontal, .bottom])

                Text("Outer radius: \(Int(outerRadius))")
                Slider(value: $outerRadius, in: 10...150, step: 1)
                    .padding([.horizontal, .bottom])

                Text("Distance: \(Int(distance))")
                Slider(value: $distance, in: 1...150, step: 1)
                    .padding([.horizontal, .bottom])

                Text("Amount: \(amount, specifier: "%.2f")")
                Slider(value: $amount)
                    .padding([.horizontal, .bottom])

                Text("Color")
                Slider(value: $hue)
                    .padding(.horizontal)
            }
        }
    }
}

struct CheckBoardView: View {

    @State private var rows = 4
    @State private var columns = 4

    var body: some View {
        CheckerBoard(rows: rows, columns: columns)
            .onTapGesture {
                withAnimation(.linear(duration: 3)){
                    self.rows = 8
                    self.columns = 16
                }
        }
    }
}

struct ContentView: View {

    var body: some View {

        // MARK: Section 1: Creating custom paths
        PathView()


        // MARK: Section 2: Paths vs Shapes
        //PathsShapesView()


        // MARK: Section 3: Adding strokBorder() support using insettableShape
       // InsettableView()


        // MARK: Section 4 : Transforming shapes using CGAffineTransform and even-odd fills
        //OddEvenFillView()


        // MARK: Section 5: Creative borders and fills using ImagePaint
        //ImagePaint()


        // MARK: Section 6: Enabling high-performace metal rendering with drawingGroup()
       // DrawingGroupView()



        // MARK: Section 7: Special Effects in SwiftUI
       // SpecialEffectView()

        // MARK: Section 8: Animating simple shapes with animatableData
        //TrapeziodView()


        // MARK: Section 9: Animating complex shapes with AnimatablePair
        //CheckBoardView()

        // MARK: Section 10:  Creating a spirograph with SwiftUI
        //SpirographContentView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
