//
//  File.swift
//  Outline
//
//  Created by Austin's Macbook Pro M3 on 2/16/25.
//

import SwiftUI

// 앱 전역의 상태관리
final class EnvironmentStateManager: ObservableObject {
    private init() { }
    static let shared = EnvironmentStateManager()

    enum Process {
        case notRunning
        case preparing
        case running
        case finished
    }

    @Published var showDetail = false
    @Published var selectedCourse: CourseWithDistanceAndScore?
    @Published var process: Process = .notRunning

    func startRunning() {
        process = .preparing
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.process = .running
        }
    }

    func finishRunning() {
        process = .finished
    }

    func goToHome() {
        process = .notRunning
    }
}
