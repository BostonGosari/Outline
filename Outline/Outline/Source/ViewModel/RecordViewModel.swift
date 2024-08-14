//
//  RecordViewModel.swift
//  Outline
//
//  Created by hyunjun on 8/14/24.
//

import Foundation
import CoreData

enum SortOption: String {
    case highscore = "스코어 순"
    case latest = "최신순"
    case oldest = "오래된 순"
    case longestDistance = "최장 거리"
    case shortestDistance = "최단 거리"
}

class RecordViewModel: ObservableObject {
    @Published var recentRunningRecords: [RunningRecord] = []
    @Published var gpsArtRunningRecords: [RunningRecord] = []
    @Published var freeRunningRecords: [RunningRecord] = []
    
    @Published var scrollOffset: CGFloat = 0
    @Published var isDeleteData = false
    @Published var showRenameSheet = false
    @Published var newCourseName = ""
    @Published var completeButtonActive = false
    @Published var isShowAlert = false
    @Published var navigateToShareMainView = false
    
    @Published var selectedSortOption: SortOption = .latest
    @Published var isSortingSheetPresented = false
    
    private let userDataModel = UserDataModel()
    var shareData = ShareModel()
    
    private let persistenceController = PersistenceController.shared
 
    func loadRunningRecords() {
        let fetchRequest: NSFetchRequest<CoreRunningRecord> = CoreRunningRecord.fetchRequest()
        
        do {
            let coreRunningRecords = try persistenceController.container.viewContext.fetch(fetchRequest)
            let runningRecords = coreRunningRecords.compactMap {
                userDataModel.convertToRunningRecord(coreRecord: $0)
            }
            
            recentRunningRecords = runningRecords
                .sorted(by: { $0.healthData.startDate > $1.healthData.startDate })
            
            gpsArtRunningRecords = runningRecords
                .filter { $0.runningType == .gpsArt }
                .sorted(by: { $0.courseData.score ?? -1 > $1.courseData.score ?? -1 })
            
            freeRunningRecords = runningRecords
                .filter { $0.runningType == .free }
                .sorted(by: { $0.healthData.startDate > $1.healthData.startDate })
            
        } catch {
            print("코어데이터에서 러닝기록을 가져오는데 실패했습니다: \(error)")
        }
    }
    
    func deleteCoreRunningRecord(_ id: String) {
        let fetchRequest: NSFetchRequest<CoreRunningRecord> = CoreRunningRecord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            let records = try persistenceController.container.viewContext.fetch(fetchRequest)
            if let recordToDelete = records.first {
                persistenceController.container.viewContext.delete(recordToDelete)
                try persistenceController.container.viewContext.save()
                loadRunningRecords()
                print("성공적으로 \(recordToDelete.courseData?.courseName ?? "") 데이터를 삭제했습니다.")
            } else {
                print("해당 ID의 데이터를 찾을 수 없습니다.")
            }
        } catch {
            print("데이터 삭제에 실패했습니다: \(error)")
        }
    }
    
    func updateCoreRunningRecord(_ id: String, courseName: String) {
        let fetchRequest: NSFetchRequest<CoreRunningRecord> = CoreRunningRecord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            let records = try persistenceController.container.viewContext.fetch(fetchRequest)
            if let recordToUpdate = records.first {
                recordToUpdate.courseData?.courseName = courseName
                try persistenceController.container.viewContext.save()
                loadRunningRecords()
                print("성공적으로 데이터를 업데이트했습니다.")
            } else {
                print("해당 ID의 데이터를 찾을 수 없습니다.")
            }
        } catch {
            print("데이터 업데이트에 실패했습니다: \(error)")
        }
    }
    
    func saveShareData(_ runningRecord: RunningRecord) {
        let courseData = runningRecord.courseData
        let healthData = runningRecord.healthData
        
        shareData = ShareModel(
            courseName: courseData.courseName,
            runningDate: healthData.startDate.dateToShareString(),
            regionDisplayName: courseData.regionDisplayName,
            distance: "\(String(format: "%.2f", healthData.totalRunningDistance/1000))km",
            cal: "\(Int(healthData.totalEnergy))Kcal",
            pace: healthData.averagePace.formattedAveragePace(),
            bpm: "\(Int(healthData.averageHeartRate))BPM",
            time: healthData.totalTime.formatMinuteSeconds(),
            userLocations: runningRecord.courseData.coursePaths
        )
    }
    
    func getCardType(for score: Int?) -> CardType {
        switch score ?? -1 {
        case 0...50: .nice
        case 51...80: .great
        case 81...100: .excellent
        default: .freeRun
        }
    }
    
    func sortingOptions(for title: String) -> [SortOption] {
        switch title {
        case "GPS 아트": [.highscore, .latest, .oldest]
        case "자유 러닝": [.latest, .oldest, .longestDistance]
        default: []
        }
    }
    
    func sortRecords(_ record1: RunningRecord, _ record2: RunningRecord) -> Bool {
        let healthData1 = record1.healthData
        let healthData2 = record2.healthData
        
        switch selectedSortOption {
        case .highscore: return record1.courseData.score ?? -1 > record2.courseData.score ?? -1
        case .latest: return healthData1.startDate > healthData2.startDate
        case .oldest: return healthData1.startDate < healthData2.startDate
        case .longestDistance: return healthData1.totalRunningDistance > healthData2.totalRunningDistance
        case .shortestDistance: return healthData1.totalRunningDistance < healthData2.totalRunningDistance
        }
    }
}
