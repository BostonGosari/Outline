//
//  InputUserInfoView.swift
//  Outline
//
//  Created by 김하은 on 10/15/23.
//

import SwiftUI
import HealthKit
import HealthKitUI

struct InputUserInfoView: View {
    
    @StateObject var viewModel = InputUserInfoViewModel()
    @StateObject var healthKitManager = HealthKitManager()
    
    private let genderList = ["설정 안 됨", "여성", "남성", "기타"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray900
                    .ignoresSafeArea()
                    .onTapGesture {
                        viewModel.currentPicker = .none
                    }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("간단한 정보를 알려주세요")
                        .font(.title)
                        .padding(EdgeInsets(top: 72, leading: 16, bottom: 8, trailing: 16))
                    
                    Text("입력하신 정보를 토대로\n더 정확한 러닝 결과를 알려드릴게요!")
                        .font(.date)
                        .padding(.horizontal, 16)
                    
                    listView
                    
                    Button(action: {
                        viewModel.defaultButtonTapped()
                    }, label: {
                        HStack(spacing: 0) {
                            Image(systemName: viewModel.defaultButtonImage)
                                .foregroundStyle(Color.customPrimary)
                                .padding(.trailing, 12)
                            
                            Text("기본값 사용")
                                .foregroundStyle(Color.gray400)
                        }
                    })
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer()
                    
                    CompleteButton(text: "완료", isActive: viewModel.isButtonActive) {
                        viewModel.moveToLocationAuthView = true
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
                
                pickerView
                    .zIndex(1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
            .foregroundStyle(Color.customWhite)
            .navigationBarBackButtonHidden()
            .onAppear {
                viewModel.requestHealthAuthorization()
            }
            .navigationDestination(isPresented: $viewModel.moveToLocationAuthView) {
                OnboardingLocationAuthView()
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
            .listRowBackground(Color.gray750)
            .listRowSeparatorTint(Color.gray700)
            
            HStack {
                Text("성별")
                Spacer()
                Text(viewModel.gender)
                    .foregroundStyle(viewModel.listTextColor(.gender))
                    .onTapGesture {
                        viewModel.currentPicker = .gender
                    }
            }
            .listRowBackground(Color.gray750)
            .listRowSeparatorTint(Color.gray700)
            
            HStack {
                Text("신장")
                Spacer()
                Text("\(viewModel.height)cm")
                    .foregroundStyle(viewModel.listTextColor(.height))
                    .onTapGesture {
                        viewModel.currentPicker = .height
                    }
            }
            .listRowBackground(Color.gray750)
            .listRowSeparatorTint(Color.gray700)
            
            HStack {
                Text("체중")
                Spacer()
                Text("\(viewModel.weight)kg")
                    .foregroundStyle(viewModel.listTextColor(.weight))
                    .onTapGesture {
                        viewModel.currentPicker = .weight
                    }
            }
            .listRowBackground(Color.gray750)
            .listRowSeparatorTint(Color.gray700)
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
                    .background(Color.gray800)
                    .preferredColorScheme(.dark)
                
            )
        case .gender:
            AnyView(
                Picker("", selection: $viewModel.gender) {
                    ForEach(genderList, id: \.self) {
                        Text("\($0)")
                    }
                }
                    .background(Color.gray800)
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
                    .background(Color.gray800)
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
                    .background(Color.gray800)
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
