//
//  Shapes.swift
//  Tyler
//
//  Created by Simon Bachmann on 04.12.20.
//

import SwiftUI

struct ShapesView: View {
    var body: some View {
        VStack {
            Text("Confetti Components")
            Group {
                RoundedCross()
                SlimRectangle()
                Triangle()
                Star()
                StarPop()
                Blink()
                Hexagon()
            }
            .frame(width: 30, height: 30)
        }
    }
}

struct RoundedCross: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.maxY/3))
        path.addQuadCurve(to: CGPoint(x: rect.maxX/3, y: rect.minY), control: CGPoint(x: rect.maxX/3, y: rect.maxY/3))
        path.addLine(to: CGPoint(x: 2*rect.maxX/3, y: rect.minY))
        
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY/3), control: CGPoint(x: 2*rect.maxX/3, y: rect.maxY/3))
        path.addLine(to: CGPoint(x: rect.maxX, y: 2*rect.maxY/3))

        path.addQuadCurve(to: CGPoint(x: 2*rect.maxX/3, y: rect.maxY), control: CGPoint(x: 2*rect.maxX/3, y: 2*rect.maxY/3))
        path.addLine(to: CGPoint(x: rect.maxX/3, y: rect.maxY))

        path.addQuadCurve(to: CGPoint(x: 2*rect.minX/3, y: 2*rect.maxY/3), control: CGPoint(x: rect.maxX/3, y: 2*rect.maxY/3))

        return path
    }
}

struct SlimRectangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: 4*rect.maxY/5))
        path.addLine(to: CGPoint(x: rect.maxX, y: 4*rect.maxY/5))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))

        return path
    }
}

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

struct Star: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.94199*width, y: 0.38242*height))
        path.addLine(to: CGPoint(x: 0.66347*width, y: 0.5923*height))
        path.addLine(to: CGPoint(x: 0.77701*width, y: 0.92204*height))
        path.addLine(to: CGPoint(x: 0.49134*width, y: 0.72201*height))
        path.addLine(to: CGPoint(x: 0.21282*width, y: 0.93189*height))
        path.addLine(to: CGPoint(x: 0.31478*width, y: 0.59838*height))
        path.addLine(to: CGPoint(x: 0.02911*width, y: 0.39835*height))
        path.addLine(to: CGPoint(x: 0.3778*width, y: 0.39227*height))
        path.addLine(to: CGPoint(x: 0.47976*width, y: 0.05877*height))
        path.addLine(to: CGPoint(x: 0.5933*width, y: 0.38851*height))
        path.addLine(to: CGPoint(x: 0.94199*width, y: 0.38242*height))
        path.closeSubpath()
        return path
    }
}

struct Blink: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.85888*width, y: 0.04969*height))
        path.addLine(to: CGPoint(x: 0.72612*width, y: 0.49239*height))
        path.addLine(to: CGPoint(x: 0.97576*width, y: 0.88135*height))
        path.addLine(to: CGPoint(x: 0.53306*width, y: 0.74858*height))
        path.addLine(to: CGPoint(x: 0.14411*width, y: 0.99822*height))
        path.addLine(to: CGPoint(x: 0.27687*width, y: 0.55553*height))
        path.addLine(to: CGPoint(x: 0.02723*width, y: 0.16657*height))
        path.addLine(to: CGPoint(x: 0.46993*width, y: 0.29934*height))
        path.addLine(to: CGPoint(x: 0.85888*width, y: 0.04969*height))
        path.closeSubpath()
        return path
    }
}

struct StarPop: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.6362*width, y: 0.99987*height))
        path.addLine(to: CGPoint(x: 0.45212*width, y: 0.69263*height))
        path.addLine(to: CGPoint(x: 0.13907*width, y: 0.86667*height))
        path.addLine(to: CGPoint(x: 0.31311*width, y: 0.55362*height))
        path.addLine(to: CGPoint(x: 0.00587*width, y: 0.36954*height))
        path.addLine(to: CGPoint(x: 0.36399*width, y: 0.36374*height))
        path.addLine(to: CGPoint(x: 0.36979*width, y: 0.00561*height))
        path.addLine(to: CGPoint(x: 0.55388*width, y: 0.31286*height))
        path.addLine(to: CGPoint(x: 0.86692*width, y: 0.13882*height))
        path.addLine(to: CGPoint(x: 0.69289*width, y: 0.45186*height))
        path.addLine(to: CGPoint(x: 1.00013*width, y: 0.63595*height))
        path.addLine(to: CGPoint(x: 0.642*width, y: 0.64175*height))
        path.addLine(to: CGPoint(x: 0.6362*width, y: 0.99987*height))
        path.closeSubpath()
        return path
    }
}

struct Hexagon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.95816*width, y: 0.51496*height))
        path.addLine(to: CGPoint(x: 0.68285*width, y: 0.93839*height))
        path.addLine(to: CGPoint(x: 0.20467*width, y: 0.89334*height))
        path.addLine(to: CGPoint(x: 0.00182*width, y: 0.42485*height))
        path.addLine(to: CGPoint(x: 0.27714*width, y: 0.00141*height))
        path.addLine(to: CGPoint(x: 0.75531*width, y: 0.04646*height))
        path.addLine(to: CGPoint(x: 0.95816*width, y: 0.51496*height))
        path.closeSubpath()
        return path
    }
}

#Preview {
    ShapesView()
}
