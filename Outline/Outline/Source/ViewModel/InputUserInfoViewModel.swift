//
//  InputUserInfoViewModel.swift
//  Outline
//
//  Created by hyebin on 10/16/23.
//

import CoreMotion
import HealthKit
import SwiftUI

enum PickerType {
    case date
    case gender
    case height
    case weight
    case none
}

class InputUserInfoViewModel: ObservableObject {
    @AppStorage("userId") var userId: String?
    
    @Published var birthday: Date = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.date(from: "2000.01.01")!
    }()
    
    @Published var defaultButtonImage: String =  "square"
    @Published var gender = "설정 안 됨"
    @Published var height = 160
    @Published var weight = 50
    @Published var currentPicker: PickerType = .none
    @Published var isDefault = false
    @Published var isButtonActive = false
    @Published var moveToLocationAuthView = false
    
    private var healthStore = HKHealthStore()
    
    func listTextColor(_ pickerType: PickerType) -> Color {
        if currentPicker == pickerType {
            Color.customPrimary
        } else {
            Color.gray400
        }
    }
    
    func defaultButtonTapped() {
        isDefault.toggle()
        
        if isDefault {
            gender = "설정 안됨"
            height = 183
            weight = 73
            defaultButtonImage = "checkmark.square"
        } else {
            gender = "설정 안됨"
            height = 160
            weight = 50
            defaultButtonImage = "square"
        }
    }
    
    func requestHealthAuthorization() {
        let quantityTypes: Set = [
            HKQuantityType(.heartRate),
            HKQuantityType(.activeEnergyBurned),
            HKQuantityType(.distanceWalkingRunning),
            HKQuantityType(.stepCount),
            HKQuantityType(.cyclingCadence),
            HKQuantityType(.runningSpeed),
            HKQuantityType.workoutType()
        ]
        
        healthStore.requestAuthorization(toShare: quantityTypes, read: quantityTypes) {_, _ in
            self.requestMotionAccess()
            self.isButtonActive = true
        }
    }
    
    func requestMotionAccess() {
        let motionManager = CMMotionActivityManager()
        
        if CMMotionActivityManager.isActivityAvailable() {
            motionManager.queryActivityStarting(from: Date(), to: Date(), to: .main) { _, _ in }
        }
    }
    
    func saveUserInfo(nickname: String) {
        guard let userId = userId else {
            print("userId is not find when update userInfo")
            return
        }
        let userInfoModel = UserInfoModel()
        let updatedUserInfo = UserInfo(
            nickname: nickname, birthday: birthday, height: height, weight: weight)
        userInfoModel.updateUserInfo(uid: userId, userInfo: updatedUserInfo) { res in
            switch res {
            case .success(let success):
                print("success to update userInfo \(success)")
            case .failure(let failure):
                print("fail to updated userInfo \(failure)")
            }
        }
    }
}
