//
//  RecordCardView.swift
//  Outline
//
//  Created by hyunjun on 8/3/24.
//

import SwiftUI
import CoreLocation

enum RecordCardSize {
    case carousel, list
}

struct RecordCardView: View {
    var size: RecordCardSize
    var type: CardType
    var name: String
    var date: String
    var coordinates: [CLLocationCoordinate2D]
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // 지도, 경로 Snapshot
            MapSnapshotImageView(coordinates: coordinates, width: size.imageFrame.width, height: size.imageFrame.height, alpha: 0.7, lineWidth: size.pathLineWidth)
                .foregroundStyle(.ultraThinMaterial)
                .frame(width: size.frame.width - size.border * 2, height: size.frame.height - size.border * 2)
                .mask(size.imageRect)
                .padding([.leading, .top], size.border)
            
            // 아웃라인 로고
            Image(type.cardFrondSideImage)
                .resizable()
                .mask {
                    size.logoRect
                        .frame(width: size.frame.width * 0.52, height: size.frame.height * 0.1)
                        .frame(width: size.frame.width, height: size.frame.height, alignment: .topLeading)
                }
                .overlay {
                    Image("CardLogo")
                        .resizable()
                        .scaledToFit()
                        .padding(.leading, size.logoPadding.leading)
                        .padding(.trailing, size.logoPadding.trailing)
                        .padding(.vertical, size.logoPadding.vertical)
                        .frame(width: size.frame.width * 0.52, height: size.frame.height * 0.1)
                        .frame(width: size.frame.width, height: size.frame.height, alignment: .topLeading)
                }
            
            // 카드 테두리
            Image(type.cardFrondSideImage)
                .resizable()
                .mask {
                    size.frameRect
                        .strokeBorder(lineWidth: size.border)
                }
            
            // 카드 바깥 테두리
            size.frameRect
                .stroke(LinearGradient(
                    colors: [.pink, .purple, .blue, .green],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ), lineWidth: size.borderLineWidth)
            
            // 홀로그램 커버
            Image(type.hologramImage)
                .resizable()
                .opacity((type == .excellent || type == .great) ? 0.7 : 0.5)
                .blendMode(.overlay)
                .mask(size.frameRect)
            
            // 러닝 이름, 날짜
            VStack(spacing: size.textSpacing) {
                Text(name)
                    .font(size.font.name)
                Text(date)
                    .font(size.font.date)
            }
            .foregroundStyle(.customWhite)
            .padding(.bottom, size.textBottomPadding)
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .frame(width: size.frame.width, height: size.frame.height)
    }
}

struct RecordEmptyCardView: View {
    var size: RecordCardSize
    
    var body: some View {
        size.frameRect
            .fill(.white5)
            .stroke(.white30, lineWidth: 1.0)
            .frame(width: size.frame.width, height: size.frame.height)
    }
}

// 카드 사이즈에 따른 값
extension RecordCardSize {
    var frame: CGSize {
        switch self {
        case .carousel: .init(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.width * 0.5 * 1.635)
        case .list: .init(width: UIScreen.main.bounds.width * 0.28, height: UIScreen.main.bounds.width * 0.28 * 1.65)
        }
    }
    
    // Snapshot 사이즈 부분
    var imageFrame: CGSize {
        switch self {
        case .carousel: .init(width: 200, height: 400)
        case .list: .init(width: 100, height: 400)
        }
    }
    
    var pathLineWidth: CGFloat {
        switch self {
        case .carousel: 4
        case .list: 2
        }
    }
    
    var frameRect: UnevenRoundedRectangle {
        switch self {
        case .carousel: .init(topLeadingRadius: 7, bottomLeadingRadius: 30, bottomTrailingRadius: 30, topTrailingRadius: 47)
        case .list: .init(topLeadingRadius: 5, bottomLeadingRadius: 15, bottomTrailingRadius: 15, topTrailingRadius: 25)
        }
    }
    
    var imageRect: UnevenRoundedRectangle {
        switch self {
        case .carousel: .init(topLeadingRadius: 0, bottomLeadingRadius: 22, bottomTrailingRadius: 22, topTrailingRadius: 39)
        case .list: .init(topLeadingRadius: 1, bottomLeadingRadius: 11, bottomTrailingRadius: 11, topTrailingRadius: 21)
        }
    }
    
    var logoRect: UnevenRoundedRectangle {
        switch self {
        case .carousel: .init(topLeadingRadius: 9, bottomLeadingRadius: 0, bottomTrailingRadius: 9, topTrailingRadius: 0)
        case .list: .init(topLeadingRadius: 5, bottomLeadingRadius: 0, bottomTrailingRadius: 5, topTrailingRadius: 0)
        }
    }
    
    var logoPadding: (leading: CGFloat, trailing: CGFloat, vertical: CGFloat) {
        switch self {
        case .carousel: (15, 18, 8)
        case .list: (8, 10, 3)
        }
    }
    
    var font: (name: Font, date: Font) {
        switch self {
        case .carousel: (.customTitle2, .customCaption)
        case .list: (.customCaption, .customTab)
        }
    }
    
    var textSpacing: CGFloat {
        switch self {
        case .carousel: 6
        case .list: 2
        }
    }
    
    var textBottomPadding: CGFloat {
        switch self {
        case .carousel: 24
        case .list: 12
        }
    }
    
    var border: CGFloat {
        switch self {
        case .carousel: 8
        case .list: 4
        }
    }
    
    var borderLineWidth: CGFloat {
        switch self {
        case .carousel: 1.5
        case .list: 1
        }
    }
}

#Preview {
    RecordCardView(size: .carousel, type: .excellent, name: "돌고래런", date: "2023.12.12", coordinates: [])
}

#Preview {
    RecordCardView(size: .list, type: .excellent, name: "돌고래런", date: "2023.12.12", coordinates: [])
}
