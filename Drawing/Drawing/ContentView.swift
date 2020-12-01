//
//  ContentView.swift
//  Drawing
//
//  Created by Daniel Kuroski on 30.11.20.
//

import SwiftUI

struct ChallengeView: View {
    struct Arrow: Shape {
        
        func path(in rect: CGRect) -> Path {
            var path = Path()
            
            let baseWidth = (rect.width * 0.4) / 2
            
            // Arrow head points
            let headTop = CGPoint(x: rect.midX, y: rect.minY)
            let headBottomLeft = CGPoint(x: rect.minX, y: rect.midY)
            let headBottomRight = CGPoint(x: rect.maxX, y: rect.midY)
            
            // Base points
            let baseTopRight = CGPoint(x: rect.midX + baseWidth, y: rect.midY)
            let baseBottomRight = CGPoint(x: rect.midX + baseWidth, y: rect.maxY)
            let baseBottomLeft = CGPoint(x: rect.midX - baseWidth, y: rect.maxY)
            let baseTopLeft = CGPoint(x: rect.midX - baseWidth, y: rect.midY)
            
            path.move(to: headBottomLeft)
            
            path.addLine(to: headTop)
            path.addLine(to: headBottomRight)
            
            path.addLine(to: baseTopRight)
            path.addLine(to: baseBottomRight)
            path.addLine(to: baseBottomLeft)
            path.addLine(to: baseTopLeft)
            
            path.addLine(to: headBottomLeft)
            
            return path
        }
    }
    
    struct ColorCyclingRectangle: View {
        var amount = 0.0
        var steps = 100
        
        var body: some View {
            ZStack {
                ForEach(0..<steps) { value in
                    Rectangle()
                        .inset(by: CGFloat(value))
                        .strokeBorder(LinearGradient(gradient: Gradient(colors: [
                            self.color(for: value, brightness: 1),
                            self.color(for: value, brightness: 0.5)
                        ]), startPoint: .top, endPoint: .bottom), lineWidth: 2)
                }
            }
            .drawingGroup()
        }
        
        func color(for value: Int, brightness: Double) -> Color {
            var targetHue = Double(value) / Double(self.steps) + self.amount
            
            if targetHue > 1 {
                targetHue -= 1
            }
            
            return Color(hue: targetHue, saturation: 1, brightness: brightness)
        }
    }
    
    @State private var lineWidth: CGFloat = 1.0
    @State private var colorCycle = 0.0
    
    var body: some View {
        VStack {
            VStack {
                Arrow()
                    .stroke(Color.red, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                    .frame(width: 100, height: 100)
                    .onTapGesture {
                        withAnimation {
                            self.lineWidth += 4.0
                        }
                    }
                
                Slider(value: $lineWidth, in: 1...10, step: 1)
                    .padding()
            }
            
            VStack {
                ColorCyclingRectangle(amount: self.colorCycle)
                    .frame(width: 300, height: 300)
                Slider(value: $colorCycle)
            }
        }
    }
}

struct SpirographView: View {
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

struct AnimateShapeView: View {
    struct Trapezoid: Shape {
        var insetAmount: CGFloat
        
        var animatableData: CGFloat {
            get { insetAmount }
            set { self.insetAmount = newValue }
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
    
    struct Checkerboard: Shape {
        var rows: Int
        var columns: Int
        
        public var animatableData: AnimatablePair<Double, Double> {
            get {
                AnimatablePair(Double(rows), Double(columns))
            }
            
            set {
                self.rows = Int(newValue.first)
                self.columns = Int(newValue.second)
            }
        }
        
        func path(in rect: CGRect) -> Path {
            var path = Path()
            
            // figure out how big each row/column needs to be
            let rowSize = rect.height / CGFloat(rows)
            let columnSize = rect.width / CGFloat(columns)
            
            // loop over all rows and columns, making alternating squares colored
            for row in 0..<rows {
                for column in 0..<columns {
                    if (row + column).isMultiple(of: 2) {
                        // this square should be colored; add a rectangle here
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
    
    @State private var insetAmount: CGFloat = 50
    @State private var rows = 4
    @State private var columns = 4
    
    var body: some View {
        VStack {
            Trapezoid(insetAmount: insetAmount)
                .frame(width: 200, height: 100)
                .onTapGesture {
                    withAnimation {
                        self.insetAmount = CGFloat.random(in: 10...90)
                    }
            }
            
            Checkerboard(rows: rows, columns: columns)
                .onTapGesture {
                    withAnimation(.linear(duration: 3)) {
                        self.rows = 8
                        self.columns = 16
                    }
                }
        }
    }
}

struct BlurBlendView: View {
    @State private var amount: CGFloat = 0.0
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color(red: 1, green: 0, blue: 0))
                    .frame(width: 200 * amount)
                    .offset(x: -50, y: -80)
                    .blendMode(.screen)
                
                Circle()
                    .fill(Color(red: 0, green: 1, blue: 0))
                    .frame(width: 200 * amount)
                    .offset(x: 50, y: -80)
                    .blendMode(.screen)
                
                Circle()
                    .fill(Color(red: 0, green: 0, blue: 1))
                    .frame(width: 200 * amount)
                    .blendMode(.screen)
            }
            .frame(width: 300, height: 300)
            
            Slider(value: $amount)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

struct CyclingView: View {
    struct ColorCyclingCircle: View {
        var amount = 0.0
        var steps = 100
        
        var body: some View {
            ZStack {
                ForEach(0..<steps) { value in
                    Circle()
                        .inset(by: CGFloat(value))
                        .strokeBorder(LinearGradient(gradient: Gradient(colors: [
                            self.color(for: value, brightness: 1),
                            self.color(for: value, brightness: 0.5)
                        ]), startPoint: .top, endPoint: .bottom), lineWidth: 2)
                }
            }.drawingGroup()
        }
        
        func color(for value: Int, brightness: Double) -> Color {
            var targetHue = Double(value) / Double(self.steps) + self.amount
            
            if targetHue > 1 {
                targetHue -= 1
            }
            
            return Color(hue: targetHue, saturation: 1, brightness: brightness)
        }
    }
    
    @State private var colorCycle = 0.0
    
    var body: some View {
        VStack {
            ColorCyclingCircle(amount: self.colorCycle)
                .frame(width: 300, height: 300)
            
            Slider(value: $colorCycle)
        }
    }
}

struct FlowerView: View {
    struct Flower: Shape {
        var petalOffset: Double = -20.0
        
        var petalWidth: Double = 100.0
        
        func path(in rect: CGRect) -> Path {
            var path = Path()
            
            for number in stride(from: 0, to: CGFloat.pi * 2, by: CGFloat.pi / 8) {
                let rotation = CGAffineTransform(rotationAngle: number)
                
                let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))
                
                let originalPetal = Path(ellipseIn: CGRect(x: CGFloat(petalOffset), y: 0, width: CGFloat(petalWidth), height: rect.width / 2))
                
                let rotatedPetal = originalPetal.applying(position)
                
                path.addPath(rotatedPetal)
            }
            
            return path
        }
    }
    
    @State private var petalOffset = -20.0
    @State private var petalWidth = 100.0
    
    var body: some View {
        VStack {
            Flower(petalOffset: petalOffset, petalWidth: petalWidth)
                //                .stroke(Color.red, lineWidth: 1)
                //                .fill(Color.red)
                .fill(Color.red, style: FillStyle(eoFill: true))
            
            Text("Offset")
            Slider(value: $petalOffset, in: -40...40)
                .padding([.horizontal, .bottom])
            
            Text("Width")
            Slider(value: $petalWidth, in: 0...100)
                .padding(.horizontal)
        }
    }
}

struct PathAndShapeView: View {
    struct Triangle: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
            
            return path
        }
    }
    
    struct Arc: InsettableShape {
        var insetAmount: CGFloat = 0
        var startAngle: Angle
        var endAngle: Angle
        var clockwise: Bool
        
        func path(in rect: CGRect) -> Path {
            let rotationAdjustment = Angle.degrees(90)
            let modifierStart = startAngle - rotationAdjustment
            let modifierEnd = endAngle - rotationAdjustment
            
            var path = Path()
            path.addArc(center: CGPoint(x: rect.midX, y: rect.minY), radius: rect.width / 2 - insetAmount, startAngle: modifierStart, endAngle: modifierEnd, clockwise: !clockwise)
            
            return path
        }
        
        func inset(by amount: CGFloat) -> some InsettableShape {
            var arc = self
            arc.insetAmount += amount
            return arc
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Triangle()
                        .stroke(Color.red, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        .frame(width: 100, height: 100)
                    
                    Arc(startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: true)
                        //                    .stroke(Color.blue, lineWidth: 10)
                        .strokeBorder(Color.blue, lineWidth: 10)
                        .frame(width: 100, height: 100)
                    Circle()
                        .strokeBorder(Color.blue, lineWidth: 10)
                }.padding()
                
                Path { path in
                    path.move(to: CGPoint(x: 200, y: 100))
                    path.addLine(to: CGPoint(x: 100, y: 300))
                    path.addLine(to: CGPoint(x: 300, y: 300))
                    path.addLine(to: CGPoint(x: 200, y: 100))
                    //            path.addLine(to: CGPoint(x: 100, y: 300))
                }
                //        .fill(Color.blue)
                .stroke(Color.blue.opacity(0.5), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: PathAndShapeView()) {
                    Text("Path and shape")
                }
                NavigationLink(destination: FlowerView()) {
                    Text("Flower")
                }
                NavigationLink(destination: CyclingView()) {
                    Text("ColorCyclingCircle")
                }
                NavigationLink(destination: BlurBlendView()) {
                    Text("BlurBlend")
                }
                NavigationLink(destination: AnimateShapeView()) {
                    Text("AnimateShape")
                }
                NavigationLink(destination: SpirographView()) {
                    Text("Spirograph")
                }
                NavigationLink(destination: ChallengeView()) {
                    Text("Challenge")
                }
            }.navigationBarTitle(Text("Drawing"))
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeView()
//                ContentView()
    }
}
