//
//  SwiftUIView.swift
//  Outline
//
//  Created by Seungui Moon on 10/31/23.
//

import SwiftUI

struct ProfileView: View {
    @State private var showDeleteUserAlert = false
    @State private var showDeleteCompleteAlert = false
    @State private var showLogoutAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("defaultProfileImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 118, height: 118)
                    .padding(.top, 18)
                
                Text("문승의")
                Divider()
                    .frame(height: 1)
                    .background(Color.gray700)
                    .padding(.top, 20)
                List {
                    Group {
                        NavigationLink {
                            ProfileUserInfoView()
                        } label: {
                            Text("내 정보")
                                .padding(.vertical, 5)
                        }
                        NavigationLink {
                            ProfileHealthInfoView()
                        } label: {
                            Text("신체 정보")
                                .padding(.vertical, 5)
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .environment(\.defaultMinListRowHeight, 50)
                .listStyle(.plain)
                .frame(height: 100)
                .padding(.top, 10)
                
                Rectangle()
                    .fill(Color.gray800)
                    .frame(height: 8)
                    .padding(.top, 20)
                List {
                    Group {
                        Button {
                            showDeleteUserAlert = true
                        } label: {
                            Text("계정 삭제")
                                .foregroundStyle(Color.customRed)
                        }
                        .alert(isPresented: $showDeleteUserAlert) {
                            Alert(
                                title: Text("계정 삭제"),
                                message: Text("이별인가요? 너무아쉬워요.\n 계정을 삭제하면 러닝 정보, 경로 기록 등\n 모든 활동 정보가 삭제 됩니다."),
                                primaryButton: .default(Text("취소"), action: {
                                    showDeleteUserAlert = false
                                }), secondaryButton: .default(Text("삭제").bold(), action: {
                                    showDeleteUserAlert = false
                                    // handle delete User
                                    showDeleteCompleteAlert = true
                                }))
                        }

                        Button {
                            showLogoutAlert = true
                        } label: {
                            Text("로그아웃")
                        }
                        .alert(isPresented: $showLogoutAlert) {
                            Alert(
                                title: Text("로그아웃"),
                                message: Text("정말 로그아웃 하시겠나요?"),
                                primaryButton: .default(Text("닫기"), action: {
                                    showLogoutAlert = false
                                }), secondaryButton: .default(Text("로그아웃").bold(), action: {
                                    showLogoutAlert = false
                                    // handle logout
                                }))
                        }

                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .environment(\.defaultMinListRowHeight, 50)
                .listStyle(.plain)
                .frame(height: 150)
                .padding(.top, 10)
                
                Spacer()
            }
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.gray900)
            .alert(isPresented: $showDeleteCompleteAlert) {
                Alert(
                    title: Text("탈퇴 완료"),
                    message: Text("탈퇴 처리가 성공적으로\n 완료되었습니다."),
                    primaryButton: .default(Text("닫기"), action: {
                        showDeleteCompleteAlert = false
                    }), secondaryButton: .default(Text("확인").bold(), action: {
                        showDeleteCompleteAlert = false
                        // handle navigate to Login View
                    }))
            }
        }
        .tint(Color.customPrimary)
    }
}

#Preview {
    ProfileView()
}
