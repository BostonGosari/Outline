//
//  SwiftUIView.swift
//  Outline
//
//  Created by Seungui Moon on 10/31/23.
//

import SwiftUI

struct ProfileView: View {
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
                            // signout
                        } label: {
                            Text("계정 삭제")
                                .foregroundStyle(Color.customRed)
                        }

                        Button {
                            // logout
                        } label: {
                            Text("로그아웃")
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
        }
        .tint(Color.customPrimary)
    }
}

#Preview {
    ProfileView()
}
