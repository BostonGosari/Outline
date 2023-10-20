//
//  CustomShareView.swift
//  Outline
//
//  Created by hyebin on 10/19/23.
//

import CoreLocation
import SwiftUI

struct CustomShareView: View {
    
    @StateObject var locationManager = LocationManager()
    @ObservedObject var viewModel: ShareViewModel

    @State private var isShowBPM = true
    @State private var isShowCal = true
    @State private var isShowPace = true
    @State private var isShowDistance = true
    
    let userLocations: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 36.0141253, longitude: 129.3471313),
        CLLocationCoordinate2D(latitude: 36.0154791, longitude: 129.3444276),
        CLLocationCoordinate2D(latitude: 36.0102547, longitude: 129.3394495),
        CLLocationCoordinate2D(latitude: 36.0097687, longitude: 129.3391061),
        CLLocationCoordinate2D(latitude: 36.008276, longitude: 129.3358231)
    ]
    
    var body: some View {
        ZStack {
            Color.gray900Color
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                customImageView
                    .padding(EdgeInsets(top: 20, leading: 49, bottom: 16, trailing: 49))
                    
                pageIndicator
                tagView
            }
        }
    }
}

extension CustomShareView {
    private var customImageView: some View {
        ZStack {
            ShareMap(userLocations: userLocations)
            runningInfo
        }
        .aspectRatio(1080.0/1920.0, contentMode: .fit)
        
    }
    
    private var runningInfo: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("고래런")
                .font(.headline)
                .foregroundStyle(Color.primaryColor)
            Text("20204.10.18")
                .font(.body)
            
            Spacer()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("11Km")
                        .opacity(isShowDistance ? 1 : 0)
                        .font(.body)
                    Text("127BPM")
                        .opacity(isShowBPM ? 1 : 0)
                        .font(.body)
                }
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("5’55”")
                        .opacity(isShowPace ? 1 : 0)
                        .font(.body)
                    Text("127Kcal")
                        .opacity(isShowCal ? 1 : 0)
                        .font(.body)
                }
            }
        }
        .padding(EdgeInsets(top: 24, leading: 16, bottom: 16, trailing: 16))
    }
    
    private var pageIndicator: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color.primaryColor)
                .frame(width: 25, height: 3)
                .padding(.trailing, 5)
            
            Rectangle()
                .fill(.white)
                .frame(width: 25, height: 3)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 168)
        .padding(.bottom, 32)
    }
    
    private var tagView: some View {
        HStack {
            TagButton(text: "BPM", isShow: isShowBPM) {
                isShowBPM.toggle()
            }
            
            TagButton(text: "칼로리", isShow: isShowCal) {
                isShowCal.toggle()
            }
            
            TagButton(text: "평균 페이스", isShow: isShowPace) {
                isShowPace.toggle()
            }
            
            TagButton(text: "거리", isShow: isShowDistance) {
                isShowDistance.toggle()
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 44)
        .padding(.bottom, 110)
    }
}

struct TagButton: View {
    let text: String
    let isShow: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            self.action()
        }  label: {
            Text(text)
                .font(.tag2)
                .foregroundStyle(isShow ? Color.blackColor : Color.whiteColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background {
                    Capsule()
                        .fill(isShow ? Color.primaryColor : Color.clear)
                        .stroke(isShow ? Color.primaryColor : Color.white)
                }
        }
    }
}
