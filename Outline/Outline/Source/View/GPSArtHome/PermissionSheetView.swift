//
//  PermissionSheetView.swift
//  Outline
//
//  Created by 김하은 on 10/27/23.
//

import SwiftUI

struct PermissionSheetView: View {
    var type: String = "health"
    @Binding var ispresented : Bool
    @StateObject var locationManager = LocationManager()
    var body: some View {
   
                ZStack {
                    Color.gray800
                    VStack {
                        Text(type=="location" ? "위치 권한 설정" : "건강 권한 허용")
                            .font(.title2)
                            .padding(.top, 44)
                        Text(type=="location"
                             ? "권한을 허용하면 정확한 러닝 정보를 확인할 수 있어요."
                             : "권한을 허용해 편리하게 Outline을 사용하세요.  위치 정보는 앱이 실행 중일때만 사용합니다.")
                        .font(.subBody)
                        .padding(.top, 4)
                        Spacer()
                        Image(type=="location"
                              ? "AuthLocation" : "AuthHealth")
                        .resizable()
                        .frame(width: 120, height: 120)
                        Spacer()
                        Button {
                            locationManager.openAppSetting()
                        } label: {
                            Text("설정으로 가기")
                                .font(.button)
                                .foregroundColor(.black)
                        }
                        .background(
                            Rectangle()
                                .foregroundColor(Color.primaryColor)
                                .frame(width: 358, height: 55)
                        )
                        .frame(width: 358, height: 55)
                        .cornerRadius(10)
                     
                        Button {
                            ispresented = false
                        } label: {
                            Text("닫기")
                                .font(.button)
                                .foregroundColor(.white)
                        }
                        .padding(.top, 20)
                    }
                }
               
                .presentationDetents([.height(420)])
                .presentationCornerRadius(35)
                .interactiveDismissDisabled()
            }
}
