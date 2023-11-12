//
//  NewRunningMetricsView.swift
//  Outline
//
//  Created by hyunjun on 11/13/23.
//

import SwiftUI

struct NewRunningMetricsView: View {
    var showDetail: Bool
    var isPaused: Bool
    
    var body: some View {
        VStack {
            if showDetail {
                VStack(spacing: 25) {
                    Text("00:00")
                        .font(.customHeadline)
                        .foregroundStyle(.customPrimary)
                    HStack {
                        MetricItem(value: "100", label: "킬로미터")
                        MetricItem(value: "99", label: "BPM")
                        MetricItem(value: "123", label: "케이던스")
                    }
                    HStack {
                        MetricItem(value: "15", label: "칼로리")
                        MetricItem(value: "-'--''", label: "평균 페이스")
                        MetricItem(value: "000", label: "000")
                            .opacity(0)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            HStack {
                VStack(alignment: .center) {
                    Text("00:00")
                        .font(.customTitle)
                    Text("진행시간")
                        .font(.customCaption)
                        .foregroundStyle(.gray400)
                }
                .padding(.leading, 40)
                Spacer()
            }
            .opacity(!isPaused && !showDetail ? 1 : 0)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct MetricItem: View {
    var value = "888'29''"
    var label = "평균 페이스"
    
    var body: some View {
        VStack {
            Text(value)
                .font(.customTitle)
            Text(label)
                .font(.customSubbody)
                .foregroundStyle(.gray200)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NewRunningMetricsView(showDetail: true, isPaused: true)
}
