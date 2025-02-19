//
//  CardDetailViewModel.swift
//  Outline
//
//  Created by Austin's Macbook Pro M3 on 2/16/25.
//

import Combine
import CoreLocation
import FirebaseAnalytics
import SwiftUI

final class CardDetailViewModel: ObservableObject {
    @AppStorage("authState") var authState: AuthState = .logout
    @Published var isUnlocked = false
    @Published var showAlert = false
    @Published var showNeedLoginSheet = false
    @Published var appear = [false, false, false]
    @Published var viewSize = 0.0
    @Published var scrollViewOffset: CGFloat = 0
    @Published var dragState: CGSize = .zero
    @Published var isDraggable = true
    @Published var progress: Double = 0.0
    @Published var showCopyLocationPopup = false

    let connectivityManager = ConnectivityManager.shared
    let locationManager = CLLocationManager()
    let runningStartManager = RunningStartManager.shared
    private let environmentStateManager = EnvironmentStateManager.shared
    private var cancellable = Set<AnyCancellable>()

    let fadeInOffset: CGFloat = 10
    let dragStartRange: CGFloat = 60
    let scrollStartRange: CGFloat = 10
    let dragLimit: CGFloat = 60
    let scrollLimit: CGFloat = 40

    var showDetailView: Bool {
        get {
            environmentStateManager.showDetail
        }
        set {
            environmentStateManager.showDetail = newValue
        }
    }
    var selectedCourse: CourseWithDistanceAndScore? {
        get {
            environmentStateManager.selectedCourse
        }
        set {
            environmentStateManager.selectedCourse = newValue
        }
    }

    init() {
        setSink()
    }

    private func setSink() {
        $isUnlocked
            .sink { [weak self] value in
                guard
                    let self,
                    value,
                    runningStartManager.checkAuthorization(),
                    let selectedCourse = environmentStateManager.selectedCourse
                else { return }

                let course = selectedCourse.course
                let runningInfo = MirroringRunningInfo(runningType: .gpsArt, courseName: course.courseName, course: course.coursePaths, heading: course.heading)

                if runningStartManager.checkDistance(course: course.coursePaths) {
                    runningStartManager.startCourse = selectedCourse.course
                    runningStartManager.startGPSArtRun()
                    connectivityManager.sendRunningInfo(runningInfo)
                    environmentStateManager.startRunning()
                    runningStartManager.start = true
                } else {
                    withAnimation {
                        self.showAlert = true
                    }
                }

                isUnlocked = false
            }
            .store(in: &cancellable)
    }

    func onAppear() {
        if authState == .lookAround {
            showNeedLoginSheet = true
        }

        // 코스별 클릭수
        Analytics.logEvent("clicked_course", parameters: [
            "card_name": selectedCourse?.course.courseName ?? "default course name",
            "card_distance": String(format: "%.0f", (selectedCourse?.distance ?? 0 )/1000 )
        ])
    }

    func changeToFreeRunning() {
        showDetailView = false
        runningStartManager.start = true
        runningStartManager.startFreeRun()

        let runningInfo = MirroringRunningInfo(runningType: .free, courseName: "자유아트", course: [])
        connectivityManager.sendRunningInfo(runningInfo)
    }

    func handleScrollViewOffset(_ value: CGFloat) {
        if dragState.width == 0 {
            scrollViewOffset = value

            if scrollViewOffset > scrollStartRange {
                viewSize = scrollViewOffset - scrollStartRange

                if scrollViewOffset > scrollLimit {
                    withAnimation(.easeInOut) {
                        showDetailView = false
                    }
                }
            } else {
                viewSize = 0
            }
        }
    }
}

/// View Animation & Gesture
extension CardDetailViewModel {
    /// 뒤로 가기 기능을 위한 customDrag function
    func onDrag(_ value: DragGesture.Value) {
        if value.translation.width > 0 {
            if value.startLocation.x < dragStartRange {
                withAnimation {
                    dragState = value.translation
                    viewSize = dragState.width
                }
                if viewSize > dragLimit {
                    withAnimation(.easeInOut) {
                        showDetailView = false
                        dragState = .zero
                    }
                }
            }
        } else {
            if value.startLocation.x > UIScreen.main.bounds.width - dragStartRange {
                withAnimation {
                    dragState = value.translation
                    viewSize = -dragState.width
                }

                if viewSize > dragLimit {
                    withAnimation(.easeInOut) {
                        showDetailView = false
                        dragState = .zero
                        viewSize = 0.0
                    }
                }
            }
        }
    }

    func dragEnded() {
        if viewSize >= dragLimit {
            withAnimation(.easeInOut) {
                showDetailView = false
                viewSize = 0.0
            }
        } else {
            withAnimation {
                dragState = .zero
                viewSize = 0.0
            }
        }
    }

    func fadeIn() {
        withAnimation(.easeOut.delay(0.3)) {
            appear[0] = true
        }
        withAnimation(.easeOut.delay(0.45)) {
            appear[1] = true
        }
        withAnimation(.easeOut.delay(0.6)) {
            appear[2] = true
        }
    }

    func fadeOut() {
        withAnimation(.easeIn(duration: 0.1)) {
            appear[0] = false
            appear[1] = false
            appear[2] = false
        }
    }
}
