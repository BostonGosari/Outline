//
//  LoginViewModel.swift
//  Outline
//
//  Created by Seungui Moon on 10/29/23.
//

import SwiftUI

import Combine
import CoreMotion
import HealthKit
import SwiftUI

enum LoginRoute: Hashable {
    case inputName
    case healthAuth
    case inputUserInfo
}

enum PickerType {
    case date
    case gender
    case height
    case weight
    case none
}

final class LoginViewModel: ObservableObject {
    // Router
    @Published var routes: [LoginRoute] = []

    // NickName
    @Published var nickname = ""
    @Published var checkInputCount = false
    @Published var checkInputWord = false
    @Published var checkNicnameDuplication = false
    @Published var isPossibleNickName = false
    @Published  var isKeyboardVisible = false
    private var cancellable: Set<AnyCancellable> = Set()
    private let userInfoModel = UserInfoModel()
    private var userNameSet: [String] = []

    // Health
    @AppStorage("authState") var authState: AuthState = .logout
    @Published var showHealthAuthentication = false
    private var healthStore = HKHealthStore()

    // UserInfo
    @AppStorage("userId") var userId: String?
    @Published var birthday: Date = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.date(from: "2000.01.01")!
    }()
    @Published var defaultButtonImage: String =  "square"
    @Published var gender = Gender.notSetted.rawValue
    @Published var height = 160
    @Published var weight = 50
    @Published var currentPicker: PickerType = .none
    @State var showSheet = false
    let genderList = Gender.allCases.map{ $0.rawValue }

    init() {
        readAllNicknames()
        $nickname
            .debounce(for: 1, scheduler: RunLoop.main)
            .sink { value in
                self.checkNicname()
            }
            .store(in: &cancellable)
    }
}

/// NickName
extension LoginViewModel {
    func readAllNicknames() {
        userInfoModel.readUserNameSet { result in
            switch result {
            case .success(let userList):
                self.userNameSet = userList
            case .failure(let error):
                print(error)
            }
        }
    }

    func checkNicname() {
        checkDuplication()
        checkCount()
        checkSymbol()

        isPossibleNickName = checkInputCount && checkInputWord && checkNicnameDuplication
    }

    func createUserName() {
        if nickname.isEmpty {
            return
        }
        userInfoModel.createUserNameSet(userName: nickname) { res in
            switch res {
            case .success(let success):
                print("success to create userName \(success)")
            case .failure(let failure):
                print("fail to create userName \(failure)")
            }
        }
    }

    private func checkDuplication() {
        if userNameSet.contains(nickname) {
            checkNicnameDuplication = false
        } else {
            checkNicnameDuplication = true
        }
    }

    private func checkCount() {
        checkInputCount = nickname.count >= 2 && nickname.count <= 16
    }

    private func checkSymbol() {
        let pattern = "^[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ\\s]+$"
        checkInputWord = nickname.range(of: pattern, options: .regularExpression) != nil
    }
}

/// Router
extension LoginViewModel {
    @MainActor
    func push(screen: LoginRoute) {
        routes.append(screen)
    }

    @MainActor
    private func pop() {
        routes.removeLast()
    }

    @ViewBuilder
    func loginView(type: LoginRoute) -> some View {
        switch type {
        case .inputName:
            InputNicknameView()
        case .healthAuth:
            HealthAuthView()
        case .inputUserInfo:
            InputUserInfoView()
        }
    }
}

/// HealthKit
extension LoginViewModel {
    @MainActor
    func requestHealthAuthorization() {
        Task {
            let quantityTypes: Set = [
                HKQuantityType(.heartRate),
                HKQuantityType(.activeEnergyBurned),
                HKQuantityType(.distanceWalkingRunning),
                HKQuantityType(.stepCount),
                HKQuantityType(.cyclingCadence),
                HKQuantityType(.runningSpeed),
                HKQuantityType.workoutType()
            ]
            try? await healthStore.requestAuthorization(toShare: quantityTypes, read: quantityTypes)
            self.push(screen: .inputUserInfo)
        }
    }
}

/// UserInfo
extension LoginViewModel {
    func listTextColor(_ pickerType: PickerType) -> Color {
        if currentPicker == pickerType {
            Color.customPrimary
        } else {
            Color.gray400
        }
    }

    func defaultButtonTapped() {
        gender = "설정 안됨"
        height = 160
        weight = 50
        defaultButtonImage = "square"
    }

    func saveUserInfo() {
        guard let userId = userId else {
            print("userId is not find when update userInfo")
            return
        }
        createUserName()
        let updatedUserInfo = UserInfo(
            nickname: nickname,
            birthday: birthday,
            height: height,
            weight: weight,
            gender: Gender(rawValue: gender) ?? .notSetted
        )
        userInfoModel.updateUserInfo(uid: userId, userInfo: updatedUserInfo) { res in
            switch res {
            case .success(let success):
                print("success to update userInfo \(success)")
            case .failure(let failure):
                print("fail to updated userInfo \(failure)")
            }
        }
        authState = .login
    }
}
