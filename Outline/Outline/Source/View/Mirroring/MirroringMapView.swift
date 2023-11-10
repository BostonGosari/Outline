//
//  MirroringMapView.swift
//  Outline
//
//  Created by hyunjun on 11/10/23.
//

import MapKit
import SwiftUI

struct MirroringMapView: View {
    @State private var position: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    @State var showDetail = false
    @State var isPaused = false
    @State var showDetailSheet = true
    @State var sheetSelection: PresentationDetent = .customSmall
    
    @State var navigationTranslation = 0.0
    
    @Namespace var mapScope
    
    var body: some View {
        ZStack {
            Map(position: $position, scope: mapScope) {
                UserAnnotation()
            }
            .mapControlVisibility(.hidden)
            VStack(alignment: .trailing) {
                HStack {
                    Image(systemName: "arrow.triangle.turn.up.right.circle")
                        .font(.system(size: 36))
                        .padding(.leading)
                        .padding(.trailing, 5)
                    VStack(alignment: .leading) {
                        Text("630m")
                            .font(.customTitle2)
                        Text("포항공과대학교 C5")
                            .font(.customSubtitle)
                            .foregroundStyle(.gray500)
                    }
                }
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background {
                    Rectangle()
                        .roundedCorners(50, corners: .bottomRight)
                        .foregroundStyle(.thinMaterial)
                        .ignoresSafeArea()
                        .overlay(alignment: .bottom) {
                            Capsule()
                                .frame(width: 40, height: 3)
                                .padding(.bottom, 9)
                                .foregroundStyle(.gray600)
                        }
                }
                .zIndex(1)
                .offset(y: navigationTranslation)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let translationY = value.translation.height
                            navigationTranslation = max(translationY, -20)
                        }
                        .onEnded { value in
                            withAnimation(.bouncy) {
                                navigationTranslation = 0.0
                            }
                        }
                )
                VStack(alignment: .trailing) {
                    Rectangle()
                        .frame(width: 113, height: 168)
                        .foregroundStyle(.white.opacity(0.4))
                    MapUserLocationButton(scope: mapScope)
                        .buttonBorderShape(.circle)
                        .tint(.white)
                        .controlSize(.large)
                }
                .padding(.trailing, 13)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .mapScope(mapScope)
        .overlay {
            VStack {
                if showDetail {
                    VStack(spacing: 25) {
                        Text("12:36")
                            .font(.customHeadline)
                            .foregroundStyle(.customPrimary)
                        HStack {
                            MetricItem(value: "1.22", label: "킬로미터")
                            MetricItem(value: "102", label: "BPM")
                            MetricItem(value: "232", label: "케이던스")
                        }
                        HStack {
                            MetricItem(value: "232", label: "칼로리")
                            MetricItem(value: "888'29''", label: "평균 페이스")
                            MetricItem(value: "000", label: "000")
                                .opacity(0)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 45)
                }
                HStack {
                    VStack(alignment: .center) {
                        Text("12:36")
                            .font(.customTitle)
                        Text("진행시간")
                            .font(.customCaption)
                            .foregroundStyle(.gray400)
                    }
                    .padding(.leading, 40)
                    Spacer()
                }
                .opacity(!isPaused && !showDetail ? 1 : 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(alignment: .topTrailing) {
                Button {
                    withAnimation {
                        showDetail.toggle()
                    }
                } label: {
                    Image(systemName: "chevron.up.circle.fill")
                        .rotationEffect(showDetail ? .degrees(-180) : .degrees(0))
                        .font(.system(size: 35))
                        .padding(.trailing, 16)
                        .foregroundStyle(.gray600, .gray800)
                        .fontWeight(.semibold)
                }
            }
            .overlay(alignment: .bottom) {
                ZStack {
                    Button {
                        
                    } label: {
                        Image(systemName: "stop.circle.fill")
                            .font(.system(size: 60))
                            .fontWeight(.ultraLight)
                            .foregroundStyle(.black, .customWhite)
                    }
                    .frame(maxWidth: .infinity, alignment: isPaused ? .leading : .center)
                    
                    Button {
                        withAnimation {
                            showDetail = false
                            isPaused = false
                        }
                    } label: {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 60))
                            .background {
                                Circle()
                                    .frame(width: 60, height: 60)
                                    .foregroundStyle(.customPrimary)
                            }
                            .foregroundStyle(.black, .customPrimary)
                    }
                    .frame(maxWidth: .infinity, alignment: isPaused ? .trailing : .center)
                    
                    Button {
                        withAnimation {
                            showDetail = true
                            isPaused = true
                        }
                    } label: {
                        Image(systemName: "pause.circle.fill")
                            .font(.system(size: 60))
                            .background {
                                Circle()
                                    .frame(width: 60, height: 60)
                                    .foregroundStyle(.customPrimary)
                            }
                            .foregroundStyle(.black, .customPrimary)
                    }
                    .buttonStyle(.plain)
                    .opacity(isPaused ? 0 : 1)
                    .animation(nil, value: isPaused)
                    .zIndex(1)
                }
                .padding(.horizontal, 90)
            }
            .padding(.top, 26)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.thinMaterial)
                    .ignoresSafeArea()
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}

extension PresentationDetent {
    static let customSmall = PresentationDetent.height(80)
    static let customMedium = PresentationDetent.height(370)
}

struct MetricItem: View {
    var value = "888'29''"
    var label = "평균 페이스"
    
    var body: some View {
        VStack {
            Text(value)
                .font(.customTitle)
            Text(label)
                .font(.customSubbody)
                .foregroundStyle(.gray200)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MirroringMapView()
}
