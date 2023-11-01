//
//  InputNicknameView.swift
//  Outline
//
//  Created by hyebin on 10/15/23.
//

import Combine
import SwiftUI

struct InputNicknameView: View {
    @StateObject var viewModel = InputNicknameViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.gray900
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("안녕하세요!\n어떻게 불러드릴까요?")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.customWhite)
                        .padding(.top, 47)
                        .padding(.horizontal, 16)
                    
                    Text("닉네임")
                        .padding(.top, 44)
                        .padding(.horizontal, 16)
                    
                    TextField("아웃라인메이트", text: $viewModel.nickname)
                        .foregroundStyle(Color.customWhite)
                        .padding(.vertical, 13)
                        .padding(.horizontal, 16)
                        .background(Color.gray700)
                        .clipShape(RoundedRectangle(cornerRadius: 10), style: /*@START_MENU_TOKEN@*/FillStyle()/*@END_MENU_TOKEN@*/)
                        .onChange(of: viewModel.nickname) {
                            viewModel.checkNicname()
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 16)
                        .padding(.horizontal, 16)
                   
                    checkView("2자리 이상 16자리 이하", viewModel.checkInputCount)
                        .padding(.bottom, 16)
                        .padding(.horizontal, 16)
                    
                    checkView("특수 문자 제외", viewModel.checkInputWord)
                        .padding(.bottom, 16)
                        .padding(.horizontal, 16)
                    
                    checkView("닉네임 중복 제외", viewModel.checkNicnameDuplication)
                        .padding(.horizontal, 16)
                    
                    CompleteButton(text: "다음", isActive: viewModel.isSuccess) {
                        if viewModel.isSuccess {
                            viewModel.moveToInputUserInfoView = true
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
            .ignoresSafeArea(.keyboard)
            .onReceive(Publishers.Merge(viewModel.keyboardWillShowPublisher, viewModel.keyboardWillHidePublisher)) { isVisible in
                viewModel.isKeyboardVisible = isVisible
            }
            .navigationDestination(isPresented: $viewModel.moveToInputUserInfoView) {
                InputUserInfoView()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    doneButton
                }
            }
        }
    }
}

extension InputNicknameView {
    private var doneButton: some View {
        Button(viewModel.isKeyboardVisible  ? "완료" : "") {
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

#Preview {
    InputNicknameView()
}
