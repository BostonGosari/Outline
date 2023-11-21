//
//  MirroringView.swift
//  Outline
//
//  Created by hyunjun on 11/22/23.
//

import SwiftUI

struct MirroringView: View {
    @StateObject private var connectivityManager = WatchConnectivityManager.shared
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Text("\(connectivityManager.runningData.distance)")
                Text("\(connectivityManager.runningData.kcal)")
                Text("\(connectivityManager.runningData.pace)")
                Text("\(connectivityManager.runningData.bpm)")
                Text("\(connectivityManager.runningData.time)")
            }
        }
    }
}

#Preview {
    MirroringView()
}
