//
//  InputNicknameView.swift
//  Outline
//
//  Created by hyebin on 10/15/23.
//

import SwiftUI

struct InputNicknameView: View {
    @Environment(\.dismiss) private var dismiss
//    @StateObject var dataTestViewModel = DataTestViewModel()
    @StateObject var viewModel = InputNicknameViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.gray900Color
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("안녕하세요!\n어떻게 불러드릴까요?")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.whiteColor)
                        .padding(.top, 30)
                    
                    Text("닉네임")
                        .padding(.top, 43)
                    
                    TextField("", text: $viewModel.nickname,
                              prompt: Text(viewModel.defaultNickname).foregroundStyle(Color.gray400Color))
                        .foregroundStyle(Color.whiteColor)
                        .padding(.vertical, 13)
                        .padding(.horizontal, 16)
                        .background(Color.gray700Color)
                        .clipShape(RoundedRectangle(cornerRadius: 10), style: /*@START_MENU_TOKEN@*/FillStyle()/*@END_MENU_TOKEN@*/)
                        .onChange(of: viewModel.nickname) {
                            viewModel.checkNicname()
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 16)
                   
                    checkView("2자리 이상 16자리 이하", viewModel.checkInputCount)
                        .padding(.bottom, 16)
                    
                    checkView("특수 문자 제외", viewModel.checkInputWord)
                        .padding(.bottom, 16)
                    
                    checkView("닉네임 중복 제외", viewModel.checkNicnameDuplication)
                    
                    CompleteButton(text: "다음", isActive: viewModel.isSuccess) {
                        if viewModel.isSuccess {
                            viewModel.moveToInputUserInfoView = true
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
                .padding()
            }
            .ignoresSafeArea(.keyboard)
            .navigationDestination(isPresented: $viewModel.moveToInputUserInfoView) {
                InputUserInfoView()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    dismissButton
                }
                ToolbarItem(placement: .topBarTrailing) {
                    doneButton
                }
            }
        }
        .onAppear {
//            dataTestViewModel.readUserNameSet()
//            viewModel.userNames = dataTestViewModel.userNameSet
            viewModel.defaultNickname = "아웃라인메이트\(viewModel.userNames.count)"
        }
    }
}

extension InputNicknameView {
    private var dismissButton: some View {
        Button {
            dismiss()
        } label: {
            HStack {
               Image(systemName: "chevron.backward")
               Text("다시 로그인")
            }
            .foregroundStyle(Color.primaryColor)
            .navigationBarBackButtonHidden(true)
        }
    }
    private var doneButton: some View {
        Button("완료") {
            dismissKeyboard()
        }
        .foregroundStyle(Color.primaryColor)
    }
    
    @ViewBuilder
    private func checkView(_ text: String, _ isTrue: Bool) -> some View {
        HStack {
            Image(systemName: isTrue ? "checkmark" : "xmark")
                .foregroundStyle(isTrue ? Color.greenColor : Color.redColor)
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
