//
//  ProfileHealthInfoView.swift
//  Outline
//
//  Created by Seungui Moon on 10/31/23.
//

import SwiftUI

struct ProfileHealthInfoView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var height: Int
    @Binding var weight: Int
    
    @State private var showHeightPicker = false
    @State private var showWeightPicker = false
    
    var completion: () -> Void = {}
    
    private var heightRange: ClosedRange<Int> {
        let min = 91
        let max = 242
        return min...max
    }
    private var weightRange: ClosedRange<Int> {
        let min = 13
        let max = 227
        return min...max
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("간단한 신체정보를 알려주세요.")
                    .font(.title2)
                    .padding(.bottom, 20)
                    .padding(.top, 40)
                Text("정확한 러닝 정보를 받으실 수 있어요.")
                    .font(.tag)
                    .foregroundStyle(Color.gray300)
                    .padding(.bottom, 0)
                Text("이 정보는 타인에게 공유되지 않아요.")
                    .font(.tag)
                    .foregroundStyle(Color.gray300)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 50)
            
            List {
                Group {
                    Button {
                        showHeightPicker.toggle()
                    } label: {
                        HStack {
                            Text("신장")
                            Spacer()
                            Text("\(height)cm")
                                .foregroundStyle(Color.gray400)
                        }
                        .frame(height: 40)
                    }

                    Button {
                        showWeightPicker.toggle()
                    } label: {
                        HStack {
                            Text("체중")
                            Spacer()
                            Text("\(weight)kg")
                                .foregroundStyle(Color.customPrimary)
                        }
                        .frame(height: 40)
                    }
                }
                .listRowBackground(Color.gray750)
                .listRowSeparator(.hidden)
            }
            .cornerRadius(10)
            .listStyle(.inset)
            .padding(.horizontal, 16)
            .frame(height: 2 * 62)
            Spacer()
        }
        .navigationTitle("내 정보")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.gray900)
        .sheet(isPresented: $showHeightPicker, content: {
            Picker("신장", selection: $height) {
                ForEach(heightRange, id: \.self) { h in
                    Text("\(h)cm")
                }
            }
            .pickerStyle(.wheel)
            .presentationDetents([.medium])
        })
        .sheet(isPresented: $showWeightPicker, content: {
            VStack {
                Picker("체중", selection: $weight) {
                    ForEach(weightRange, id: \.self) { w in
                        Text("\(w)kg")
                    }
                }
                .pickerStyle(.wheel)
                .presentationDetents([.medium])
            }
        })
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    completion()
                    dismiss()
                } label: {
                    Text("완료")
                        .foregroundStyle(Color.customPrimary)
                }
            }
        }
    }
}
