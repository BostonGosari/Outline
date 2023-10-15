//
//  GPSArtHomeView.swift
//  Outline
//
//  Created by 김하은 on 10/15/23.
//

import SwiftUI

struct GPSArtHomeView: View {
    @State private var scrollOffset: CGFloat = 0

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ScrollView {
                    VStack {
                        Text("캐러셀이 들어갈 곳입니당")
                   }
                   .padding(.top, 60)
                   .background(GeometryReader {
                        Color.clear.preference(
                            key: ViewOffsetKey.self,
                            value: -$0.frame(in: .named("scroll")).origin.y)
                    })
                    .onPreferenceChange(ViewOffsetKey.self) { offset in
                         self.scrollOffset = offset
                    }
                }
                Rectangle()
                    .edgesIgnoringSafeArea(.top)
                    .foregroundColor(scrollOffset > -60 ? Color.grayHeaderColor : Color.clear)
                    .frame(height: 60)
                HStack {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                    Spacer()
                    Image(systemName: "person.crop.circle")
                        .font(.title)
                        .foregroundColor(Color.first)
                }
                .padding()
                .frame(height: 60)
            }
            .background(
                BackgroundBlur()
            )
        }
        
    }
}

#Preview {
    GPSArtHomeView()
}
