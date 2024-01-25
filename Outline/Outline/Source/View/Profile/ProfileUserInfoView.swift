//
//  ProfileUserInfoView.swift
//  Outline
//
//  Created by Seungui Moon on 10/31/23.
//

import Combine
import SwiftUI

struct ProfileUserInfoView: View {
    @StateObject private var profileUserInfoViewModel = ProfileUserInfoViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @Binding var nickname: String
    @Binding var birthday: Date
    @Binding var gender: Gender
    
    var completion: () -> Void
    
    private var dateRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .year, value: -120, to: Date())!
        let max = Calendar.current.date(byAdding: .year, value: 0, to: Date())!
        return min...max
    }
    
    var body: some View {
        VStack {
            ZStack {
                Image("defaultProfileImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 118, height: 118)
            }
            .padding(.top, 18)
            
            TextField("\(nickname)", text: $profileUserInfoViewModel.nickname)
                .foregroundStyle(Color.customWhite)
                .padding(.vertical, 13)
                .padding(.horizontal, 16)
                .background(Color.gray700)
                .clipShape(RoundedRectangle(cornerRadius: 10), style: /*@START_MENU_TOKEN@*/FillStyle()/*@END_MENU_TOKEN@*/)
                .onChange(of: profileUserInfoViewModel.nickname) {
                    profileUserInfoViewModel.checkNicname()
                }
                .padding(.top, 8)
                .padding(.bottom, 16)
                .padding(.horizontal, 16)
            if profileUserInfoViewModel.isKeyboardVisible {
                HStack {
                    VStack(alignment: .leading) {
                        checkView("2자리 이상 16자리 이하", profileUserInfoViewModel.checkInputCount)
                            .padding(.bottom, 16)
                            .padding(.horizontal, 16)
                        
                        checkView("특수 문자 제외", profileUserInfoViewModel.checkInputWord)
                            .padding(.bottom, 16)
                            .padding(.horizontal, 16)
                        
                        checkView("닉네임 중복 제외", profileUserInfoViewModel.checkNicnameDuplication)
                            .padding(.horizontal, 16)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
            }
            
            Divider()
                .frame(height: 1)
                .background(Color.gray700)
                .padding(.vertical, 20)
            
            List {
                Group {
                    Button {
                        profileUserInfoViewModel.showBirthdayPicker.toggle()
                    } label: {
                        HStack {
                            Text("생년월일")
                                .font(.customSubbody)
                            Spacer()
                            Text(birthday.dateToShareString())
                                .font(.customSubbody)
                                .foregroundStyle(Color.gray400)
                        }
                        .frame(height: 38)
                    }
                    Button {
                        profileUserInfoViewModel.showGenderPicker.toggle()
                    } label: {
                        HStack {
                            Text("성별")
                                .font(.customSubbody)
                            Spacer()
                            Text("\(gender.rawValue)")
                                .font(.customSubbody)
                                .foregroundStyle(Color.customPrimary)
                        }
                        .frame(height: 38)
                    }
                }
                .listRowBackground(Color.gray750)
            }
            .scrollDisabled(true)
            .cornerRadius(10)
            .listStyle(.inset)
            .padding(.horizontal, 16)
            .frame(height: 2 * 60)
            Spacer()
        }
        .navigationTitle("내 정보")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.gray900)
        .onReceive(Publishers.Merge(profileUserInfoViewModel.keyboardWillShowPublisher, profileUserInfoViewModel.keyboardWillHidePublisher)) { isVisible in
            profileUserInfoViewModel.isKeyboardVisible = isVisible
        }
        .sheet(isPresented: $profileUserInfoViewModel.showBirthdayPicker, onDismiss: {
            completion()
        }, content: {
            DatePicker(
                "", selection: $birthday,
                in: dateRange,
                displayedComponents: [.date]
            )
            .datePickerStyle(.wheel)
            .presentationDetents([.medium])
        })
        .sheet(isPresented: $profileUserInfoViewModel.showGenderPicker, onDismiss: {
            completion()
        }, content: {
            Picker("성별", selection: $gender) {
                ForEach(Gender.allCases, id: \.self) { gender in
                    Text(gender.rawValue)
                }
            }
            .pickerStyle(.wheel)
            .presentationDetents([.medium])
        })
        .onChange(of: profileUserInfoViewModel.isKeyboardVisible, { _, newValue in
            if newValue == false {
                if profileUserInfoViewModel.isSuccessToCheckName {
                    profileUserInfoViewModel.updateUserNameSet(oldUserName: nickname, newUserName: profileUserInfoViewModel.nickname)
                    nickname = profileUserInfoViewModel.nickname
                    completion()
                } else {
                    profileUserInfoViewModel.nickname = nickname
                }
            }
        })
    }
}

extension ProfileUserInfoView {
    private var doneButton: some View {
        Button(profileUserInfoViewModel.showBirthdayPicker || profileUserInfoViewModel.showGenderPicker  ? "완료" : "") {
            dismissKeyboard()
        }
        .foregroundStyle(Color.customPrimary)
    }
    
    @ViewBuilder
    private func checkView(_ text: String, _ isTrue: Bool) -> some View {
        HStack {
            Image(systemName: isTrue ? "checkmark" : "xmark")
                .foregroundStyle(isTrue ? Color.customGreen : Color.customRed)
            Text(text)
        }
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .background(Color.gray750)
            .cornerRadius(10)
    }
}
