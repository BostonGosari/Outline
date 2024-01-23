//
//  SwiftUIView.swift
//  Outline
//
//  Created by Seungui Moon on 10/31/23.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("authState") var authState: AuthState = .logout
    @AppStorage("userId") var userId: String?
    @AppStorage("voiceOniPhone") var voiceOniPhone: Bool = true
    @AppStorage("voiceOnWatch") var voiceOnWatch: Bool = true
    @ObservedObject private var profileViewModel = ProfileViewModel()
    
    @State private var showDeleteUserAlert = false
    @State private var showDeleteCompleteAlert = false
    @State private var showLogoutAlert = false
    @State private var showNeedLoginSheet = false
    
    // 추후 데이터 연결 필요
    @State private var userProfileImage = "defaultProfileImage"
    
    var body: some View {
        
        ZStack {
            
            VStack {
                Image(userProfileImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 118, height: 118)
                    .padding(.top, 18)
                
                Text(profileViewModel.userInfo.nickname)
                    .font(.customTag)
                Divider()
                    .frame(height: 1)
                    .background(Color.gray700)
                    .padding(.top, 20)
                List {
                    Group {
                        NavigationLink {
                            ProfileUserInfoView(
                                nickname: $profileViewModel.userInfo.nickname,
                                birthday: $profileViewModel.userInfo.birthday,
                                gender: $profileViewModel.userInfo.gender,
                                completion: profileViewModel.saveUserInfoOnDB
                            )
                        } label: {
                            Text("내 정보")
                                .font(.customSubbody)
                                .padding(.vertical, 5)
                        }
                        NavigationLink {
                            ProfileHealthInfoView(
                                height: $profileViewModel.userInfo.height,
                                weight: $profileViewModel.userInfo.weight,
                                completion: profileViewModel.saveUserInfoOnDB
                            )
                        } label: {
                            Text("신체 정보")
                                .font(.customSubbody)
                                .padding(.vertical, 5)
                        }
                        NavigationLink {
                            ProfileVoiceView(isVoiceOniPhone: $voiceOniPhone, isVoiceOnWatch: $voiceOnWatch)
                        } label: {
                            Text("음성 설정")
                                .font(.customSubbody)
                                .padding(.vertical, 5)
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .scrollDisabled(true)
                .environment(\.defaultMinListRowHeight, 50)
                .listStyle(.plain)
                .frame(height: 150)
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
                                .font(.customSubbody)
                                .foregroundStyle(Color.customRed)
                        }
                        .alert(isPresented: $showDeleteUserAlert) {
                            Alert(
                                title: Text("계정 삭제").font(.customButton),
                                message: Text("이별인가요? 너무아쉬워요. 계정을 삭제하면 러닝 정보, 경로 기록 등\n 모든 활동 정보가 삭제 됩니다.")
                                    .font(.customCaption),
                                primaryButton: .default(Text("취소"), action: {
                                    showDeleteUserAlert = false
                                }), secondaryButton: .default(Text("삭제").bold(), action: {
                                    showDeleteUserAlert = false
                                    profileViewModel.signOut()
                                    showDeleteCompleteAlert = true
                                }))
                        }

                        Button {
                            showLogoutAlert = true
                        } label: {
                            Text("로그아웃")
                                .font(.customSubbody)
                        }
                        .alert(isPresented: $showLogoutAlert) {
                            Alert(
                                title: Text("로그아웃").font(.customButton),
                                message: Text("정말 로그아웃 하시겠나요?")
                                    .font(.customCaption),
                                primaryButton: .default(Text("닫기"), action: {
                                    showLogoutAlert = false
                                }), secondaryButton: .default(Text("로그아웃").bold(), action: {
                                    showLogoutAlert = false
                                    profileViewModel.logOut()
                                    // handle logout
                                }))
                        }

                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .scrollDisabled(true)
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
                    title: Text("탈퇴 완료").font(.customButton),
                    message: Text("탈퇴 처리가 성공적으로 완료되었습니다.").font(.customCaption),
                    primaryButton: .default(Text("닫기"), action: {
                        showDeleteCompleteAlert = false
                        self.authState = .logout
                        self.userId = nil
                    }), secondaryButton: .default(Text("확인").bold(), action: {
                        showDeleteCompleteAlert = false
                        self.authState = .logout
                        self.userId = nil
                    })
                )
            }
            
        }
        .sheet(isPresented: $showNeedLoginSheet) {
            NeedLoginSheet(type: .userInfo) {
                dismiss()
            }
        }
        .onAppear {
            switch authState {
            case .login:
                profileViewModel.loadUserInfo()
            case .lookAround:
                showNeedLoginSheet = true
            default:
                return
            }
        }
    }
}

#Preview {
    ProfileView()
}
