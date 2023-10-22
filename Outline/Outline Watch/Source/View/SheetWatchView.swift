//
//  SheetWatchView.swift
//  Outline Watch App
//
//  Created by hyunjun on 10/19/23.
//

import SwiftUI

struct SheetWatchView: View {
    
    @State var isShow = false
    @State var isShow2 = false
    
    var body: some View {
        VStack {
            Button {
                isShow.toggle()
            } label: {
                Text("sheet")
            }
            Button {
                isShow2.toggle()
            } label: {
                Text("sheet")
            }
        }
        .sheet(isPresented: $isShow) {
            VStack {
                VStack(alignment: .leading) {
                    Text("5m이내에 도착 지점이 있어요.")
                    Text("러닝을 완료할까요?")
                }
                .padding()
                .padding(.top)
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .foregroundStyle(.gray.opacity(0.2))
                }
                Button("조금 더 진행하기") {
                    isShow.toggle()
                }
                Button("완료하기") {
                    isShow.toggle()
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                
            }
            .overlay(alignment: .topLeading) {
                Image(systemName: "flag.circle")
                    .font(.system(size: 40))
                    .foregroundColor(.green)
                    .padding(16)
                    .ignoresSafeArea()
            }
            .toolbar(.hidden, for: .automatic)
        }
        .sheet(isPresented: $isShow2) {
            VStack {
                VStack(alignment: .leading) {
                    Text("30초 이하는 기록되지 않아요.")
                    Text("러닝을 종료할까요?")
                }
                .padding()
                .padding(.top)
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .foregroundStyle(.gray.opacity(0.2))
                }
                Button("계속 러닝하기") {
                    isShow2.toggle()
                }
                Button("종료하기") {
                    isShow2.toggle()
                }
                .buttonStyle(.borderedProminent)
                .tint(.gray.opacity(0.5))
                
            }
            .overlay(alignment: .topLeading) {
                Image(systemName: "map.circle")
                    .font(.system(size: 40))
                    .foregroundColor(.green)
                    .padding(16)
                    .ignoresSafeArea()
            }
            .toolbar(.hidden, for: .automatic)
        }
    }
}

#Preview {
    SheetWatchView()
}
