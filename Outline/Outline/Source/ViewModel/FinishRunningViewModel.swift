//
//  FinishRunningViewModel.swift
//  Outline
//
//  Created by hyebin on 10/18/23.
//

import CoreData
import CoreLocation
import SwiftUI

class FinishRunningViewModel: ObservableObject {
    @Published var isShowPopup = false {
        didSet {
            if isShowPopup {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.easeInOut(duration: 1)) {
                        self.isShowPopup = false
                    }
                }
            }
        }
    }
    @Published var navigateToShareMainView = false
    @Published var runningRecord: RunningRecord?
    
    private let userDataModel = UserDataModel()
    private let persistenceController = PersistenceController.shared
    var shareData = ShareModel()
    
    init() {
        loadLastRunningRecord()
    }
    
    func loadLastRunningRecord() {
        let fetchRequest: NSFetchRequest<CoreRunningRecord> = CoreRunningRecord.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \CoreRunningRecord.healthData?.startDate, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = 1
        
        do {
            let coreRunningRecord = try persistenceController.container.viewContext.fetch(fetchRequest).first
            guard let data = coreRunningRecord else { return }
            runningRecord = userDataModel.convertToRunningRecord(coreRecord: data)
        } catch {
            print("코어데이터에서 러닝기록을 가져오는데 실패했습니다: \(error)")
        }
    }
    
    func saveShareData() {
        guard let runningRecord = runningRecord else { return }
        let courseData = runningRecord.courseData
        let healthData = runningRecord.healthData
        
        shareData = ShareModel(
            courseName: courseData.courseName,
            runningDate: healthData.startDate.dateToShareString(),
            distance: "\(String(format: "%.2f", healthData.totalRunningDistance/1000))km",
            time: healthData.totalTime.formatMinuteSeconds(),
            userLocations: runningRecord.courseData.coursePaths,
            heading: courseData.heading
        )
        
        navigateToShareMainView = true
    }
    
    func updateCoreRunningRecord(courseName: String) {
        guard let runningRecord = runningRecord else { return }
        let fetchRequest: NSFetchRequest<CoreRunningRecord> = CoreRunningRecord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", runningRecord.id)

        do {
            let records = try persistenceController.container.viewContext.fetch(fetchRequest)
            if let recordToUpdate = records.first {
                recordToUpdate.courseData?.courseName = courseName
                try persistenceController.container.viewContext.save()
                print("성공적으로 데이터를 업데이트했습니다.")
            } else {
                print("해당 ID의 데이터를 찾을 수 없습니다.")
            }
        } catch {
            print("데이터 업데이트에 실패했습니다: \(error)")
        }
    }
    
    func getCardType(for score: Int?) -> CardType {
        switch score ?? -1 {
        case 0...50: .nice
        case 51...80: .great
        case 81...100: .excellent
        default: .freeRun
        }
    }
}
