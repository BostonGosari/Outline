//
//  MirroringMetricsView.swift
//  Outline Watch App
//
//  Created by hyunjun on 11/22/23.
//

import SwiftUI

struct MirroringMetricsView: View {
    @StateObject private var connectivityManager = WatchConnectivityManager.shared
    
    var body: some View {
        VStack(alignment: .center) {
            Text(connectivityManager.runningData.time.formatMinuteSeconds())
                .font(.customHeadline)
                .monospacedDigit()
                .foregroundStyle(.customPrimary)
                .padding(.bottom)
            HStack {
                Spacer()
                VStack {
                    Text("\((connectivityManager.runningData.distance/1000).formatted(.number.precision(.fractionLength(2))))")
                        .font(.customLargeTitle)
                        .foregroundColor(.white)
                    Text("킬로미터")
                        .font(.customBody)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.gray500)
                    
                }
                Spacer()
                VStack {
                    Text(connectivityManager.runningData.pace.formattedCurrentPace())
                        .font(.customLargeTitle)
                        .foregroundColor(.white)
                    Text("페이스")
                        .font(.customBody)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.gray500)
                }
                .padding(.leading, 20)
                Spacer()
            }
        }
        .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MirroringMetricsView()
}
