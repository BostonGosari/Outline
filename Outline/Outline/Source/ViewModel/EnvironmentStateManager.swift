//
//  File.swift
//  Outline
//
//  Created by Austin's Macbook Pro M3 on 2/16/25.
//

import SwiftUI

final class EnvironmentStateManager: ObservableObject {
    private init() { }
    static let shared = EnvironmentStateManager()

    @Published var showDetail = false
    @Published var selectedCourse: CourseWithDistanceAndScore?

    func startRunning() {
        showDetail = false
    }
}
