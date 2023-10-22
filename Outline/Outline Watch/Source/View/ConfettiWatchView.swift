//
//  ConfettiWatchView.swift
//  Outline Watch App
//
//  Created by hyunjun on 10/19/23.
//

import SwiftUI

struct ConfettiWatchView: View {
    
    @State var counter = 0
    
    var body: some View {
        Confetti(counter: $counter,
                 num: 30,
                 confettis: [
                    .shape(.circle),
                    .shape(.smallCircle),
                    .shape(.triangle),
                    .shape(.square),
                    .shape(.smallSquare),
                    .shape(.slimRectangle),
                    .shape(.hexagon),
                    .shape(.star),
                    .shape(.starPop),
                    .shape(.blink)
                 ],
                 colors: [.blue, .yellow],
                 confettiSize: 7,
                 openingAngle: .degrees(60),
                 closingAngle: .degrees(120),
                 repetitions: 3,
                 repetitionInterval: 0.5
        )
        .onAppear {
            counter += 1
        }
    }
}

#Preview {
    ConfettiWatchView()
}
