//
//  CourseListWatchView.swift
//  Outline Watch App
//
//  Created by Hyunjun Kim on 10/16/23.
//

import SwiftUI

struct CourseListWatchView: View {
    
    @State private var detailViewNavigate = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: -5) {
                    Button {
                        // action here
                    } label: {
                        HStack {
                            Image(systemName: "play.circle")
                            Text("자유코스")
                        }
                        .foregroundColor(.black)
                        .frame(height: 48)
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .foregroundStyle(.green)
                        }
                    }
                    .buttonStyle(.plain)
                    .scrollTransition { content, phase in
                        content
                            .scaleEffect(phase.isIdentity ? 1 : 0.8)
                            .opacity(phase.isIdentity ? 1 : 0.8)
                    }
                    .padding(.bottom, 8)
                    
                    ForEach(0..<5) {_ in
                        Button {
                            print("button clicked")
                        } label: {
                            VStack {
                                Text("시티런")
                                    .padding(.leading, 4)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .overlay(alignment: .trailing) {
                                        Button {
                                            detailViewNavigate = true
                                            print("ellipsis clicked")
                                        } label: {
                                            Image(systemName: "ellipsis")
                                                .font(.system(size: 24))
                                                .frame(width: 48, height: 48)
                                        }
                                        .buttonStyle(.plain)
                                        .padding(.trailing, -4)
                                    }
                                SampleCourePath()
                                    .stroke(lineWidth: 4)
                                    .scaledToFit()
                                    .frame(height: 75)
                                    .foregroundColor(.green)
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 8)
                            .frame(maxWidth: .infinity)
                            .background {
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .foregroundStyle(.ultraThinMaterial)
                            }
                        }
                        .buttonStyle(.plain)
                        .scrollTransition { content, phase in
                            content
                                .scaleEffect(phase.isIdentity ? 1 : 0.8)
                                .opacity(phase.isIdentity ? 1 : 0.8)
                        }
                    }
                }
            }
            .navigationTitle("러닝")
            .navigationDestination(isPresented: $detailViewNavigate) {
                DetailView()
            }
        }
    }
}

struct DetailView: View {
    var body: some View {
        Text("detailView")
    }
}

struct SampleCourePath: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.68307*width, y: 0.03416*height))
        path.addCurve(to: CGPoint(x: 0.42506*width, y: 0.44577*height), control1: CGPoint(x: 0.48813*width, y: -0.03248*height), control2: CGPoint(x: 0.42984*width, y: 0.2808*height))
        path.addCurve(to: CGPoint(x: 0.0237*width, y: 0.61729*height), control1: CGPoint(x: 0.27097*width, y: 0.38861*height), control2: CGPoint(x: -0.02503*width, y: 0.34288*height))
        path.addCurve(to: CGPoint(x: 0.54969*width, y: 0.97047*height), control1: CGPoint(x: 0.06702*width, y: 0.86118*height), control2: CGPoint(x: 0.36077*width, y: 0.95024*height))
        path.addCurve(to: CGPoint(x: 0.66651*width, y: 0.91992*height), control1: CGPoint(x: 0.59191*width, y: 0.97499*height), control2: CGPoint(x: 0.63319*width, y: 0.95554*height))
        path.addLine(to: CGPoint(x: 0.91485*width, y: 0.65442*height))
        path.addCurve(to: CGPoint(x: 0.96734*width, y: 0.40077*height), control1: CGPoint(x: 0.97216*width, y: 0.59316*height), control2: CGPoint(x: 0.99871*width, y: 0.49034*height))
        path.addCurve(to: CGPoint(x: 0.68307*width, y: 0.03416*height), control1: CGPoint(x: 0.91588*width, y: 0.25382*height), control2: CGPoint(x: 0.82298*width, y: 0.08199*height))
        path.closeSubpath()
        return path
    }
}

#Preview {
    CourseListWatchView()
}
