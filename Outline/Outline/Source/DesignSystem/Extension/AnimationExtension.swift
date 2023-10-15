//
//  AnimationExtension.swift
//  Outline
//
//  Created by Hyunjun Kim on 10/15/23.
//

import SwiftUI

extension Animation {
    static let openCard = Animation.spring(response: 0.5, dampingFraction: 0.6)
    static let closeCard = Animation.spring(response: 0.6, dampingFraction: 0.6)
}
