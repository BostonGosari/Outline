//
//  CardModel.swift
//  Outline
//
//  Created by hyunjun on 11/19/23.
//

import SwiftUI

enum CardType {
    case freeRun
    case nice
    case great
    case excellent
    
    var cardFrondSideImage: String {
        switch self {
        case .nice, .freeRun:
            "NormalCardFrontSide"
        case .great, .excellent:
            "CardFrontSide"
        }
    }
    
    var cardBackSideImage: String {
        switch self {
        case .freeRun, .nice:
            "NormalCardBackSide"
        case .great, .excellent:
            "CardBackSide"
        }
    }
    
    var hologramImage: String {
        switch self {
        case .freeRun, .nice, .great:
            "Hologram1"
        case .excellent:
            "Hologram2"
        }
    }
}
