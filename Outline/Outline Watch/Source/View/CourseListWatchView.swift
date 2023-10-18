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
                                Circle()
                                    .stroke(lineWidth: 4)
                                    .foregroundColor(.green)
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 8)
                            .frame(height: 136)
                            .frame(maxWidth: .infinity)
                            .background {
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .foregroundStyle(.gray)
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
                Text("DetailView")
            }
        }
    }
}

#Preview {
    CourseListWatchView()
}
