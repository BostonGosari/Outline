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
                    .font(.customTitle2)
                    .padding(.bottom, 20)
                    .padding(.top, 40)
                Text("정확한 러닝 정보를 받으실 수 있어요.")
                    .font(.customTag)
                    .foregroundStyle(Color.gray300)
                    .padding(.bottom, 0)
                Text("이 정보는 타인에게 공유되지 않아요.")
                    .font(.customTag)
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
                                .font(.customSubbody)
                            Spacer()
                            Text("\(height)cm")
                                .font(.customSubbody)
                                .foregroundStyle(showHeightPicker ? Color.customPrimary : Color.gray400)
                        }
                        .frame(height: 38)
                    }

                    Button {
                        showWeightPicker.toggle()
                    } label: {
                        HStack {
                            Text("체중")
                                .font(.customSubbody)
                            Spacer()
                            Text("\(weight)kg")
                                .font(.customSubbody)
                                .foregroundStyle(showWeightPicker ? Color.customPrimary : Color.gray400)
                        }
                        .frame(height: 38)
                    }
                }
                .listRowBackground(Color.gray750)
                .listRowSeparator(.hidden)
            }
            .scrollDisabled(true)
            .cornerRadius(10)
            .listStyle(.inset)
            .padding(.horizontal, 16)
            .frame(height: 2 * 60)
            
            Spacer()
        }
        .navigationTitle("신체 정보")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.gray900)
        .sheet(isPresented: $showHeightPicker, onDismiss: {
            completion()
        }, content: {
            Picker("신장", selection: $height) {
                ForEach(heightRange, id: \.self) { h in
                    Text("\(h)cm")
                        .font(.customSubbody)
                }
            }
            .pickerStyle(.wheel)
            .presentationDetents([.height(240)])
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            .clipped()
        })
        .sheet(isPresented: $showWeightPicker, onDismiss: {
            completion()
        }, content: {
            VStack {
                Picker("체중", selection: $weight) {
                    ForEach(weightRange, id: \.self) { w in
                        Text("\(w)kg")
                            .font(.customSubbody)
                    }
                }
                .pickerStyle(.wheel)
                .presentationDetents([.height(240)])
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                .clipped()
            }
        })
    }
}

#Preview {
    ProfileHealthInfoView(height: .constant(124), weight: .constant(124))
}
