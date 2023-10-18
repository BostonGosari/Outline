//
//  FinishRunningViewModel.swift
//  Outline
//
//  Created by hyebin on 10/18/23.
//

import CoreLocation
import SwiftUI

class FinishRunningViewModel: ObservableObject {
    @Published var isShowPopup = false {
        didSet {
            if isShowPopup {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isShowPopup = false
                }
            }
        }
    }

    var courseName = "고래런"
    var courseRegion = "서울시 동작구"
    
    var startTime = "오후 12:47"
    var endTime = "오후 4:50"
    var date = "10월 9일 (월)"
    
    var kilometer = "1.22/5"
    var time = "47:02"
    var pace = "-'--"
    var bpm = "102"
    var cal = "232"
    var cadence = "128"
    
    var userLocations: [CLLocationCoordinate2D] = []
    
    func readRunningData() {
        // coreData에서 읽어오기
    }
}
