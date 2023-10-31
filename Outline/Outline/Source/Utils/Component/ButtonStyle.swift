//
//  ButtonStyle.swift
//  Outline
//
//  Created by hyunjun on 10/30/23.
//

import SwiftUI

struct CardButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.bouncy, value: configuration.isPressed)
    }
}
