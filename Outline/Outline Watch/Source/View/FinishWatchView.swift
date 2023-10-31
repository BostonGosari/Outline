//
//  FinishWatchView.swift
//  Outline Watch App
//
//  Created by hyunjun on 10/19/23.
//

import SwiftUI

struct FinishWatchView: View {
    private let connectionWatchModel = ConnectingWatchModel()
    
    @State var completionPercentage: Double = 100

    var body: some View {
        VStack {
            switch completionPercentage {
            case 100:
                finalImage("FinalImage1")
            case 50..<100:
                finalImage("FinalImage2")
            case ..<10:
                finalImage("FinalImage3")
            default:
                Text("\(completionPercentage, specifier: "%.2f")%")
            }
        }
    }
    
    @ViewBuilder
    private func finalImage(_ imageName: String) -> some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(height: 118)
            .ignoresSafeArea()
    }
}

#Preview {
    FinishWatchView(completionPercentage: 100.0)
}
