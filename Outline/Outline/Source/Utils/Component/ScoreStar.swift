//
//  ScoreStar.swift
//  Outline
//
//  Created by 김하은 on 11/21/23.
//
import SwiftUI

enum ScoreCategory: String {
    case notyet
    case nice
    case great
    case excellent
}

enum StarSize {
    case big
    case small
}

struct ScoreStar: View {
    var score: Int
    var size: StarSize
    
    var category: ScoreCategory {
        switch score {
        case 0:
            return .notyet
        case 1...50:
            return .nice
        case 51...90:
            return .great
        case 91...100:
            return .excellent
        default:
            return .notyet
        }
    }
    
    var blurSize: CGFloat {
        switch category {
        case .notyet:
            return 0
        case .nice, .great, .excellent:
            return 20
        }
    }
    
    var body: some View {
        VStack {
            switch size {
            case .big:
                Image(category.rawValue)
                   .resizable()
                   .scaledToFit()
                   .frame(height: 24 + blurSize*2)
                   .offset(x: -blurSize, y: -blurSize)
                   
            case .small:
                Image(category.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 12 + blurSize)
                    .offset(x: -blurSize/2, y: blurSize/2)
            }
        }
      
    }
}
