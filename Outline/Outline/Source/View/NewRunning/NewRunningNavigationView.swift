//
//  NewRunningNavigationView.swift
//  Outline
//
//  Created by hyunjun on 11/13/23.
//

import AVFoundation
import SwiftUI

struct NewRunningNavigationView: View {
    @State private var synthesizer = AVSpeechSynthesizer()
    @State private var textToSpeech = false
    
    @Binding var direction: String
    @Binding var distance: Double
    var nextDirection: String
    var showDetailNavigation: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "arrow.triangle.turn.up.right.circle")
                    .font(.system(size: 36))
                    .padding(.leading)
                    .padding(.trailing, 5)
                VStack(alignment: .leading) {
                    Text("\(Int(distance))m")
                        .font(.customTitle2)
                    Text(direction)
                        .font(.customSubtitle)
                        .foregroundStyle(.gray500)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if showDetailNavigation {
                Rectangle()
                    .frame(width: 310, height: 1)
                    .padding(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundStyle(.gray600)
                HStack {
                    Image(systemName: "arrow.triangle.turn.up.right.circle")
                        .font(.system(size: 36))
                        .padding(.leading)
                        .padding(.trailing, 5)
                    VStack(alignment: .leading) {
                        if nextDirection == "직진" {
                            Text("경로를 따라 계속 이동")
                                .font(.customTitle2)
                        } else {
                            Text(nextDirection)
                                .font(.customTitle2)
                            Text("포항공과대학교 C5")
                                .font(.customSubtitle)
                                .foregroundStyle(.gray500)
                        }
                    }
                }
            }
        }
        .onChange(of: direction) {
            textToSpeech = false
            if direction == "직진" {
                textToSpeech("그대로 쭉 직진 하세요")
                textToSpeech = true
            }
        }
        .onChange(of: distance) {
            if distance <= 15 && !textToSpeech {
                textToSpeech("\(Int(distance))미터 후 \(direction)하세요)")
                textToSpeech = true
            }
        }
    }
    
    private func textToSpeech(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        utterance.rate = 0.5
        
        synthesizer.speak(utterance)
    }
}

//#Preview {
//    NewRunningNavigationView(
//        distance: 0,
//        direction: "우회전",
//        showDetailNavigation: false
//    )
//}
