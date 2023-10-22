//
//  InputNicknameView.swift
//  Outline
//
//  Created by hyebin on 10/15/23.
//

import SwiftUI

struct InputNicknameView: View {
    @Environment(\.dismiss) private var dismiss
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
                        .padding(.top, 60)
                    
                    HStack {
                        Text("닉네임")
                            .foregroundStyle(Color.whiteColor)
                        
                        Text("한글, 영어, 숫자 사용가능")
                            .foregroundStyle(Color.gray400Color)
                            .font(.caption)
                    }
                    .padding(.top, 45)
                    
                    HStack {
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
                        
                        Image(systemName: viewModel.checkImage)
                            .foregroundStyle(viewModel.currentState == .success ? Color.green : Color.thirdColor)
                            .font(.system(size: 20))
                    }
                    .padding(.top, 8)
                   
                    Text(viewModel.wrongText)
                        .foregroundStyle(Color.third)
                        .padding(.top, 6)
                        .padding(.leading, 16)
                }
                .padding()
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
            viewModel.doneButtonTapped()
        }
        .foregroundStyle(Color.primaryColor)
    }
    
}

#Preview {
    InputNicknameView()
}
