//
//  CustomShareView.swift
//  Outline
//
//  Created by hyebin on 10/19/23.
//

import CoreLocation
import MapKit
import SwiftUI

struct CustomShareView: View {
    
    @StateObject var locationManager = LocationManager()
    @ObservedObject var viewModel: ShareViewModel

    @State private var isShowBPM = true
    @State private var isShowCal = true
    @State private var isShowPace = true
    @State private var isShowDistance = true
    
    @State private var renderedImage: UIImage?
    @State private var mapView = MKMapView()
    
    var body: some View {
        ZStack {
            Color.gray900Color
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                customImageView
                    .padding(EdgeInsets(top: 20, leading: 49, bottom: 16, trailing: 49))
                if let renderedImage = renderedImage {
                    Image(uiImage: renderedImage)
                }
                Button {
                    renderLayerImage()
                } label: {
                    Text("render Image")
                }
                pageIndicator
                tagView
            }
        }
    }
}

extension CustomShareView {
    private func renderLayerImage(){
        
    }
}

extension CustomShareView {
    private var customImageView: some View {
        ZStack {
            ShareMap(mapView: $mapView, userLocations: viewModel.runningData.userLocations)
                .overlay {
                    LinearGradient(colors: [.black.opacity(0), .black], startPoint: .center, endPoint: .bottom)
                }
            runningInfo
        }
        .aspectRatio(1080.0/1920.0, contentMode: .fit)
        
    }
    
    private var runningInfo: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(viewModel.runningData.courseName)
                .font(.headline)
                .foregroundStyle(Color.primaryColor)
            Text(viewModel.runningData.runningDate)
                .font(.body)
            
            Spacer()
            
            HStack {
                VStack(alignment: .leading) {
                    Text(viewModel.runningData.distance)
                        .opacity(isShowDistance ? 1 : 0)
                        .font(.body)
                    Text(viewModel.runningData.bpm)
                        .opacity(isShowBPM ? 1 : 0)
                        .font(.body)
                }
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(viewModel.runningData.pace)
                        .opacity(isShowPace ? 1 : 0)
                        .font(.body)
                    Text(viewModel.runningData.cal)
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
            TagButton(text: "거리", isShow: isShowDistance) {
                isShowDistance.toggle()
            }
            TagButton(text: "BPM", isShow: isShowBPM) {
                isShowBPM.toggle()
            }
            TagButton(text: "평균 페이스", isShow: isShowPace) {
                isShowPace.toggle()
            }
            TagButton(text: "칼로리", isShow: isShowCal) {
                isShowCal.toggle()
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


