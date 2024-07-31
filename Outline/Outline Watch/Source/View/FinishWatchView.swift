//
//  FinishWatchView.swift
//  Outline Watch App
//
//  Created by hyunjun on 10/19/23.
//

import SwiftUI

struct FinishWatchView: View {    
    var score = 100

    var body: some View {
        VStack {
            switch score {
            case 80..<100:
                FinalImage("FinalImage1")
            case 50..<80:
                FinalImage("FinalImage2")
            case ..<10:
                FinalImage("FinalImage3")
            default:
                Text("\(score, specifier: "%.2f")%")
            }
        }
    }
}

#Preview {
    FinishWatchView(score: 80)
}
