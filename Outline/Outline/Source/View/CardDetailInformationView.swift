//
//  CardDetailInformationView.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/15/23.
//

import SwiftUI

struct CardDetailInformationView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text("#어려움")
                    .frame(width: 70, height: 23)
                    .background {
                        Capsule()
                            .stroke()
                    }
                    .foregroundColor(.firstColor)
                Text("#5km")
                    .frame(width: 70, height: 23)
                    .background {
                        Capsule()
                            .stroke()
                    }
                Text("#2h39m")
                    .frame(width: 70, height: 23)
                    .background {
                        Capsule()
                            .stroke()
                    }
            }
            .fontWeight(.semibold)
            .font(.caption)
                        
            VStack(alignment: .leading, spacing: 8) {
                Text("경상북도 포항시 남구 효자로")
                    .font(.title3)
                    .bold()
                Text("포항의 야경을 바라보며 뛸 수 있는 러닝코스")
                    .foregroundStyle(.gray)
            }
            
            Divider()
            
            Text("경로 정보")
                .font(.title3)
                .bold()
            VStack(alignment: .leading, spacing: 17) {
                HStack {
                    HStack {
                        Image(systemName: "flag")
                        Text("추천 시작 위치")
                    }
                    .foregroundColor(.firstColor)
                    Text("포항시 남구 효자로")
                }
                HStack {
                    HStack {
                        Image(systemName: "location")
                        Text("거리")
                    }
                    .foregroundColor(.firstColor)
                    Text("9km")
                }
                HStack {
                    HStack {
                        Image(systemName: "clock")
                        Text("예상 소요 시간")
                    }
                    .foregroundColor(.firstColor)
                    Text("2h 39m")
                }
                HStack {
                    HStack {
                        Image(systemName: "arrow.triangle.turn.up.right.diamond")
                        Text("골목길")
                    }
                    .foregroundColor(.firstColor)
                    Text("많음")
                }
            }
            .padding(.horizontal, 10)
            
            Divider()
            
            Text("경로 지도")
                .font(.title3)
                .bold()
            VStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 200)
                    .foregroundStyle(.thinMaterial)
                Text("경로 제작 고사리님 @alsgiwc")
                    .foregroundStyle(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 20)
        .padding(.horizontal)
    }
}

#Preview {
    CardDetailInformationView()
}
