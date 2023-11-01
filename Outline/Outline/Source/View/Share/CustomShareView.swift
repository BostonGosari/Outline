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
    
    @ObservedObject var viewModel: ShareViewModel

    @State private var isShowBPM = true
    @State private var isShowCal = true
    @State private var isShowPace = true
    @State private var isShowDistance = true
    
    // handle Image
    @Binding var renderedImage: UIImage?
    @State private var mapView = MKMapView()
    @State private var mapViewRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 29, longitude: 136), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @State private var imageWidth: CGFloat = 0
    @State private var imageHeight: CGFloat = 0
    
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
        
    var body: some View {
        ZStack {
            Color.gray900
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                customImageView
                    .padding(EdgeInsets(top: 20, leading: 49, bottom: 16, trailing: 49))
                pageIndicator
                tagView
            }
            
        }
        .onChange(of: viewModel.currentPage, {
            if viewModel.currentPage == 0 {
                renderLayerImage()
            }
        })
        .onAppear {
            renderLayerImage()
        }
    }
}

extension CustomShareView {
    private func renderLayerImage() {
        renderMapViewAsImage(width: Int(imageWidth), height: Int(imageHeight))
    }
    private func renderMapViewAsImage(width: Int, height: Int) {
        let options: MKMapSnapshotter.Options = .init()
        options.region = mapViewRegion
        options.size = CGSize(width: width, height: height)
        options.mapType = .standard
        options.showsBuildings = true
        
        let snapshotter = MKMapSnapshotter(
            options: options
        )
        snapshotter.start { snapshot, error in
           if let snapshot = snapshot {
               let renderedMapImage = snapshot.image
               renderedImage = overlayMapInfo(renderdImage: renderedMapImage).asImage(size: CGSize(width: width, height: height))
           } else if let error = error {
              print(error)
           }
        }
    }
    private func overlayMapInfo(renderdImage: UIImage) -> some View {
        ZStack {
            Group {
                Group {
                    Image(uiImage: renderdImage)
                    
                    PathGenerateManager.caculateLinesInRect(width: imageWidth, height: Double(imageWidth * 1920 / 1080), coordinates: viewModel.runningData.userLocations, region: mapView.region)
                        .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                }
                .overlay {
                    LinearGradient(colors: [.black.opacity(0), .black], startPoint: .center, endPoint: .bottom)
                }
                runningInfo
            }
            .offset(y: -30)
        }
        .frame(width: imageWidth, height: imageHeight)
    }
}

extension CustomShareView {
    private var customImageView: some View {
        ZStack {
            Map(position: $position) {
                MapPolyline(coordinates: viewModel.runningData.userLocations)
                    .stroke(.customPrimary, lineWidth: 8)
            }
            .mapControls {
            }
            .frame(width: imageWidth, height: imageHeight)
            .overlay {
                LinearGradient(colors: [.black.opacity(0), .black], startPoint: .center, endPoint: .bottom)
            }
            
            runningInfo
            GeometryReader { proxy in
                HStack {}
                    .onAppear {
                        imageWidth = proxy.size.width
                        imageHeight = proxy.size.height
                }
            }
        }
        .aspectRatio(1080.0/1920.0, contentMode: .fit)
    }
    
    private var runningInfo: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(viewModel.runningData.courseName)
                .font(.headline)
                .foregroundStyle(Color.customPrimary)
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
                .fill(Color.customPrimary)
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
                .foregroundStyle(isShow ? Color.customBlack : Color.customWhite)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background {
                    Capsule()
                        .fill(isShow ? Color.customPrimary : Color.clear)
                        .stroke(isShow ? Color.customPrimary : Color.white)
                }
        }
    }
}
