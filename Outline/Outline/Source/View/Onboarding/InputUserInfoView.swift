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
    @AppStorage("authState") var authState: AuthState = .logout
    @StateObject var viewModel = InputUserInfoViewModel()
    @StateObject var healthKitManager = HealthKitManager()
    
    @State private var showSheet = false
    
    var userNickName = "default"
    private let genderList = ["설정 안 됨", "여성", "남성", "기타"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray900
                    .ignoresSafeArea()
                    .onTapGesture {
                        viewModel.currentPicker = .none
                        showSheet = false
                    }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("간단한 정보를 알려주세요")
                        .font(.customTitle)
                        .padding(EdgeInsets(top: getSafeArea().bottom == 0 ? 50 : 72, leading: 16, bottom: 8, trailing: 16))
                    
                    Text("입력하신 정보를 토대로\n더 정확한 러닝 결과를 알려드릴게요!")
                        .font(.customDate)
                        .foregroundStyle(Color.gray300)
                        .padding(.horizontal, 16)
                    
                    listView
                        .frame(height: 217)
                        .padding(.top, 26)
                        .padding(.bottom, 17)
                       
                    Button(action: {
                        viewModel.defaultButtonTapped()
                        viewModel.currentPicker = .none
                        showSheet = false
                    }, label: {
                        HStack(spacing: 0) {
                            Image(systemName: viewModel.defaultButtonImage)
                                .foregroundStyle(viewModel.defaultButtonImage == "checkmark.square" ? Color.customPrimary : Color.gray400)
                                .padding(.trailing, 12)
                            
                            Text("기본값 사용")
                                .foregroundStyle(Color.gray400)
                        }
                    })
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                        .frame(maxHeight: .infinity)
                    
                    CompleteButton(text: "완료", isActive: true) {
                        viewModel.saveUserInfo(nickname: userNickName)
                        authState = .login
                    }
                    
                    .frame(alignment: .bottom)
                    .padding(.bottom, 16)
                }
            }
            .foregroundStyle(Color.customWhite)
            .navigationBarBackButtonHidden()
            .overlay {
                pickerView
                    .transition(.move(edge: .bottom))
                    .animation(.spring, value: showSheet)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
}

extension InputUserInfoView {
    private var listView: some View {
        List {
            HStack {
                Text("생년월일")
                    .font(.customSubbody)
                Spacer()
                Text(viewModel.birthday.dateToBirthDay())
                    .foregroundStyle(viewModel.listTextColor(.date))
                    .onTapGesture {
                        viewModel.currentPicker = .date
                        showSheet = true
                        if viewModel.isDefault {
                            viewModel.defaultButtonTapped()
                        }
                    }
                
            }
            .listRowBackground(Color.gray750)
            .listRowSeparatorTint(Color.gray700)
            
            HStack {
                Text("성별")
                    .font(.customSubbody)
                Spacer()
                Text(viewModel.gender)
                    .foregroundStyle(viewModel.listTextColor(.gender))
                    .onTapGesture {
                        viewModel.currentPicker = .gender
                        showSheet = true
                        if viewModel.isDefault {
                            viewModel.defaultButtonTapped()
                        }
                    }
            }
            .listRowBackground(Color.gray750)
            .listRowSeparatorTint(Color.gray700)
            
            HStack {
                Text("신장")
                    .font(.customSubbody)
                Spacer()
                Text("\(viewModel.height)cm")
                    .foregroundStyle(viewModel.listTextColor(.height))
                    .onTapGesture {
                        viewModel.currentPicker = .height
                        showSheet = true
                        if viewModel.isDefault {
                            viewModel.defaultButtonTapped()
                        }
                    }
            }
            .listRowBackground(Color.gray750)
            .listRowSeparatorTint(Color.gray700)
            
            HStack {
                Text("체중")
                    .font(.customSubbody)
                Spacer()
                Text("\(viewModel.weight)kg")
                    .foregroundStyle(viewModel.listTextColor(.weight))
                    .onTapGesture {
                        viewModel.currentPicker = .weight
                        showSheet = true
                        if viewModel.isDefault {
                            viewModel.defaultButtonTapped()
                        }
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
    private var pickerView: some View {
        ZStack {
            switch viewModel.currentPicker {
            case .date:
                DatePicker("", selection: $viewModel.birthday, displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .padding(.horizontal, 30)
                    .background(Color.gray800)
                
            case .gender:
                Picker("", selection: $viewModel.gender) {
                    ForEach(genderList, id: \.self) {
                        Text("\($0)")
                    }
                }
                .background(Color.gray800)
                .pickerStyle(.wheel)
                
            case .height:
                Picker("", selection: $viewModel.height) {
                    ForEach(Array(91...242), id: \.self) {
                        Text("\($0)cm")
                    }
                }
                .pickerStyle(.wheel)
                .background(Color.gray800)
                
            case .weight:
                Picker("", selection: $viewModel.weight) {
                    ForEach(Array(13...227), id: \.self) {
                        Text("\($0)kg")
                    }
                }
                .pickerStyle(.wheel)
                .background(Color.gray800)
                
            case .none:
                EmptyView()
                    .frame(height: 0)
            }
        }
    }
}

#Preview {
    InputUserInfoView()
}
