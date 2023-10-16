//
//  CourseListWatchView.swift
//  Outline Watch App
//
//  Created by Hyunjun Kim on 10/16/23.
//

import SwiftUI

struct CourseListWatchView: View {
    var body: some View {
        NavigationStack {
            List {
                Button {
                    // action here
                } label: {
                    HStack {
                        Image(systemName: "play.circle")
                        Text("자유코스")
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                }
                .listRowBackground(
                    Color.green
                        .clipped()
                        .cornerRadius(12)
                )
                
                ForEach(0..<5) { _ in
                    Button {
                        print("button clicked")
                    } label: {
                        VStack {
                            Text("시티런")
                                .padding(.leading, 4)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .overlay(alignment: .trailing) {
                                    Button {
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
                        .frame(height: 136)
                    }
                    .listRowBackground(
                        Color.secondary
                            .clipped()
                            .cornerRadius(24)
                    )
                }
            }
            .navigationTitle("러닝")
        }
    }
}

#Preview {
    CourseListWatchView()
}
