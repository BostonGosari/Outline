//
//  FinalImage.swift
//  Outline Watch App
//
//  Created by hyunjun on 7/28/24.
//

import SwiftUI

struct FinalImage: View {
    var image: String
    
    init(_ image: String) {
        self.image = image
    }
    
    var body: some View {
        Image(image)
            .resizable()
            .scaledToFit()
            .frame(height: 118)
            .ignoresSafeArea()
            .padding(.bottom, 20)
    }
}
