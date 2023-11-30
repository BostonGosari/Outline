//
//  NewRunningNavigationView.swift
//  Outline
//
//  Created by hyunjun on 11/13/23.
//

import AVFoundation
import SwiftUI

struct NewRunningNavigationView: View {
    @StateObject private var locationManager = LocationManager.shared
    
    @State private var synthesizer = AVSpeechSynthesizer()
    @State private var audioPlayer: AVAudioPlayer?
    
    let courseName: String
    var showDetailNavigation: Bool
        
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: getDirectionImage(locationManager.direction))
                    .font(.system(size: 36))
                    .padding(.leading)
                    .padding(.trailing, 5)
                VStack(alignment: .leading) {
                    Text("\(Int(locationManager.distance))m")
                        .font(.customTitle2)
                    Text("\(locationManager.direction) 방면")
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
                
                if let nextDirection = locationManager.nextDirection {
                    HStack {
                        Image(systemName: getDirectionImage(nextDirection.direction))
                            .font(.system(size: 36))
                            .padding(.leading)
                            .padding(.trailing, 5)
                    
                        VStack(alignment: .leading) {
                            Text("\(nextDirection.distance)m")
                                .font(.customTitle2)
                            Text("\(nextDirection.direction) 방면")
                                .font(.customSubtitle)
                                .foregroundStyle(.gray500)
                        }
                    }
                }
            }
        }
        .onAppear {
            playAlertSound()
            textToSpeech("\(courseName) 안내를 시작합니다.")
        }
        .onChange(of: locationManager.distance) {
            if locationManager.distance <= 20 {
                textToSpeech("\(Int(locationManager.distance))미터 후 \(locationManager.direction)하세요)")
            }
        }
        .onChange(of: locationManager.nearHotSopt) {
            if locationManager.nearHotSopt {
                if let hotSpot = locationManager.hotSpot {
                    playAlertSound()
                    textToSpeech(hotSpot.description)
                }
            }
        }
    }
    
    private func getDirectionImage(_ direction: String) -> String {
        switch direction {
        case "우회전", "오른쪽":
            return "arrow.turn.up.right"
        case "좌회전", "왼쪽":
            return "arrow.turn.up.left"
        default:
            return "arrow.right.circle"
        }
    }
    
    private func textToSpeech(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        utterance.rate = 0.5
        
        synthesizer.speak(utterance)
    }
    
    private func playAlertSound() {
        guard let url = Bundle.main.url(forResource: "alert", withExtension: "mp3") else { return }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch let error {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}

#Preview {
    NewRunningNavigationView(courseName: "고래런", showDetailNavigation: false)
}
