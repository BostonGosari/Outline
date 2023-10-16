//
//  InputUserInfoView.swift
//  Outline
//
//  Created by 김하은 on 10/15/23.
//
import os
import SwiftUI
import HealthKit
import HealthKitUI

struct InputUserInfoView: View {
   
    @EnvironmentObject var workoutManager: WorkoutManager
    @StateObject var viewModel = InputUserInfoViewModel()

    private let genderList = ["설정 안 됨", "여성", "남성", "기타"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray900Color
                    .ignoresSafeArea()
                    .onTapGesture {
                        viewModel.currentPicker = .none
                    }
                
                VStack(alignment: .center, spacing: 0) {
                    Text("사용자 정보 입력")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("러닝 거리, 페이스, 칼로리 소모량 등\n더욱 정확한 러닝 결과를 위해 다음 정보가 필요합니다.")
                        .multilineTextAlignment(.center)
                        .padding(.top, 24)
                    
                    listView
                        .frame(maxHeight: .infinity)
                        .padding(.bottom, 140)
                    
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            viewModel.defaultButtonTapped()
                        }, label: {
                            Image(systemName: viewModel.defaultButtonImage)
                                .foregroundStyle(Color.firstColor)
                        })
                        
                        Text("기본값 사용")
                            .foregroundStyle(Color.gray400Color)
                    }
                    .padding(.bottom, 24)
                    
                    Text("정보를 입력하고 싶지 않은 경우, 기본값 사용을 선택해주세요.\n기본값을 바탕으로 러닝을 시작합니다.")
                        .multilineTextAlignment(.center)
                        .font(.caption)
                        .foregroundStyle(Color.gray400Color)
                        .padding(.bottom, 36)
                }
                .padding(.top, 150)
                
                pickerView
                    .zIndex(1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                
            }
            .foregroundStyle(Color.white0Color)
            .toolbar {
                Button("다음") {
                    
                }
                .foregroundStyle(Color.firstColor)
            }
            .navigationBarBackButtonHidden()
            .onAppear {
                //                workoutManager.requestAuthorization()
            }
        }
    }
}

extension InputUserInfoView {
    private var listView: some View {
        List {
            HStack {
                Text("생년월일")
                Spacer()
                Text(viewModel.birthday.dateToBirthDay())
                    .foregroundStyle(viewModel.listTextColor(.date))
                    .onTapGesture {
                        viewModel.currentPicker = .date
                    }
                
            }
            .listRowBackground(Color.gray750Color)
            .listRowSeparatorTint(Color.gray700Color)
            
            HStack {
                Text("성별")
                Spacer()
                Text(viewModel.gender)
                    .foregroundStyle(viewModel.listTextColor(.gender))
                    .onTapGesture {
                        viewModel.currentPicker = .gender
                    }
            }
            .listRowBackground(Color.gray750Color)
            .listRowSeparatorTint(Color.gray700Color)
            
            HStack {
                Text("신장")
                Spacer()
                Text("\(viewModel.height)cm")
                    .foregroundStyle(viewModel.listTextColor(.height))
                    .onTapGesture {
                        viewModel.currentPicker = .height
                    }
            }
            .listRowBackground(Color.gray750Color)
            .listRowSeparatorTint(Color.gray700Color)
            
            HStack {
                Text("체중")
                Spacer()
                Text("\(viewModel.weight)kg")
                    .foregroundStyle(viewModel.listTextColor(.weight))
                    .onTapGesture {
                        viewModel.currentPicker = .weight
                    }
            }
            .listRowBackground(Color.gray750Color)
            .listRowSeparatorTint(Color.gray700Color)
        }
        .scrollDisabled(true)
        .scrollContentBackground(.hidden)
    }
}

extension InputUserInfoView {
    private var pickerView: AnyView {
        switch viewModel.currentPicker {
        case .date:
             AnyView(
                DatePicker("", selection: $viewModel.birthday, displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .padding(.horizontal, 30)
                    .background(Color.gray800Color)
                    .preferredColorScheme(.dark)
                    
            )
        case .gender:
            AnyView(
                Picker("", selection: $viewModel.gender) {
                    ForEach(genderList, id: \.self) {
                        Text("\($0)")
                    }
                }
                    .background(Color.gray800Color)
                    .preferredColorScheme(.dark)
                    .pickerStyle(.wheel)
            )
        case .height:
            AnyView(
                Picker("", selection: $viewModel.height) {
                    ForEach(Array(91...242), id: \.self) {
                        Text("\($0)cm")
                    }
                }
                    .pickerStyle(.wheel)
                    .background(Color.gray800Color)
                    .preferredColorScheme(.dark)
            )
        case .weight:
            AnyView(
                Picker("", selection: $viewModel.weight) {
                    ForEach(Array(13...227), id: \.self) {
                        Text("\($0)kg")
                    }
                }
                    .pickerStyle(.wheel)
                    .background(Color.gray800Color)
                    .preferredColorScheme(.dark)
            )
        case .none:
            AnyView(EmptyView())
        }
    }
}

#Preview {
    InputUserInfoView()
}
