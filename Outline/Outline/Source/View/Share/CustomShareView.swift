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
    
    // handle Image
    @Binding var renderedImage: UIImage?
    @State private var mapView = MKMapView()
    @State private var imageWidth: CGFloat = 0
    @State private var imageHeight: CGFloat = 0
    
    private let pathManager = PathGenerateManager.shared
    
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
}

extension CustomShareView {
    private var customImageView: some View {
        ZStack {
            ShareMap(mapView: $mapView, userLocations: viewModel.runningData.userLocations)
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

extension CustomShareView {
    func renderMapViewAsImage(width: Int, height: Int) {
        let options: MKMapSnapshotter.Options = .init()
        options.region = mapView.region
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
    func overlayMapInfo(renderdImage: UIImage) -> some View {
        ZStack {
            Group {
                Group {
                    Image(uiImage: renderdImage)
                        
                    pathManager.caculateLinesInRect(width: imageWidth, height: Double(imageWidth * 1920 / 1080), coordinates: viewModel.runningData.userLocations, region: mapView.region)
                        .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
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

extension PathGenerateManager {
    func caculateLinesInRect(
        width: Double,
        height: Double,
        coordinates: [CLLocationCoordinate2D],
        region: MKCoordinateRegion
    ) -> some Shape {
        let canvasData = calculateCanvaDataInRect(width: width, height: height, region: region)
        var path = Path()
        
        let startPosition = calculateRelativePoint(coordinate: coordinates[0], canvasData: canvasData)
        path.move(to: CGPoint(x: startPosition[0], y: -startPosition[1]))

        for coordinate in coordinates {
            let position = calculateRelativePoint(coordinate: coordinate, canvasData: canvasData)
            path.addLine(to: CGPoint(x: position[0], y: -position[1]))
        }
        
        return path
    }
    
    private func calculateCanvaDataInRect(width: Double, height: Double, region: MKCoordinateRegion) -> CanvasDataForShare {
        let minLon = region.center.longitude - region.span.longitudeDelta / 2
//        let maxLon = region.center.longitude + region.span.longitudeDelta / 2
//        let minLat = region.center.latitude - region.span.latitudeDelta / 2
        let maxLat = region.center.latitude + region.span.latitudeDelta / 2
        
        let calculatedHeight = region.span.latitudeDelta * 1000000
        let calculatedWidth = region.span.longitudeDelta * 1000000
        
        let relativeWidthScale: Double = width / calculatedWidth
        let relativeHeightScale: Double = height / calculatedHeight
        
        let fittedWidth = calculatedWidth * relativeWidthScale
        let fittedHeight = calculatedHeight * relativeHeightScale
        return CanvasDataForShare(
            width: Int(fittedWidth),
            height: Int(fittedHeight),
            widthScale: relativeWidthScale,
            heightScale: relativeHeightScale,
            zeroX: minLon,
            zeroY: maxLat
            )
    }
    
    private func calculateCanvaData(coordinates: [CLLocationCoordinate2D], width: Double, height: Double) -> CanvasData {
        var minLat: Double = 90
        var maxLat: Double = -90
        var minLon: Double = 180
        var maxLon: Double = -180
        for coordinate in coordinates {
            if coordinate.latitude < minLat {
                minLat = coordinate.latitude
            }
            if coordinate.latitude > maxLat {
                maxLat = coordinate.latitude
            }
            if coordinate.longitude < minLon {
                minLon = coordinate.longitude
            }
            if coordinate.longitude > maxLon {
                maxLon = coordinate.longitude
            }
        }
        let calculatedHeight = (maxLat - minLat) * 1000000
        let calculatedWidth = (maxLon - minLon) * 1000000
        
        var relativeScale: Double = 0
        
        if calculatedWidth > calculatedHeight {
            relativeScale = width / calculatedWidth
        } else {
            relativeScale = height / calculatedHeight
        }
        let fittedWidth = calculatedWidth * relativeScale
        let fittedHeight = calculatedHeight * relativeScale
        
        return CanvasData(
            width: Int(fittedWidth),
            height: Int(fittedHeight),
            scale: relativeScale,
            zeroX: minLon,
            zeroY: maxLat
            )
    }
    
    func calculateDeltaAndCenter(coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        var minLat: Double = 90
        var maxLat: Double = -90
        var minLon: Double = 180
        var maxLon: Double = -180
        for coordinate in coordinates {
            if coordinate.latitude < minLat {
                minLat = coordinate.latitude
            }
            if coordinate.latitude > maxLat {
                maxLat = coordinate.latitude
            }
            if coordinate.longitude < minLon {
                minLon = coordinate.longitude
            }
            if coordinate.longitude > maxLon {
                maxLon = coordinate.longitude
            }
        }
        let latitudeDelta = maxLat - minLat
        let longitudeDelta = maxLon - minLon
        let centerLatitude = (maxLat + minLat) / 2
        let centerLongitude = (maxLon + minLon) / 2
        
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude), span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta))
    }
    
    private func calculateRelativePoint(coordinate: CLLocationCoordinate2D, canvasData: CanvasDataForShare) -> [Int] {
        let posX = Int((coordinate.longitude - canvasData.zeroX) * canvasData.widthScale * 1000000)
        let posY = Int((coordinate.latitude - canvasData.zeroY) * canvasData.heightScale * 1000000)
        return [posX, posY]
    }
}
