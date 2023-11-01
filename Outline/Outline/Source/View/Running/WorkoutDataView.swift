import SwiftUI

struct WorkoutDataView: View {
    @StateObject var runningManager = RunningStartManager.shared
    @StateObject var runningDataManager = RunningDataManager.shared
    let weight: Double = 60
    
    var body: some View {
        ZStack {
            Color("Gray900").ignoresSafeArea()
            VStack {
                digitalTimer
                Spacer()
                workOutDataGrid
            }
            .onChange(of: runningDataManager.distance) { _, _ in
                runningDataManager.kilocalorie = weight * (runningDataManager.totalDistance + runningDataManager.distance) / 1000 * 1.036
            }
            .frame(height: 300)
            .padding()
        }
    }
    
    private var workOutDataGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 36) {
            let averagePace = (runningDataManager.totalTime + runningDataManager.time) / (runningDataManager.totalDistance + runningDataManager.distance) * 1000
            
            workoutDataItem(value: String(format: "%.2f", (runningDataManager.totalDistance + runningDataManager.distance) / 1000), label: "킬로미터")
            workoutDataItem(value: averagePace.formattedAveragePace(), label: "평균 페이스")
            workoutDataItem(value: String(format: "%.0f", runningDataManager.kilocalorie), label: "칼로리")
            workoutDataItem(value: "--", label: "BPM")
        }
    }
    
    private var digitalTimer: some View {
        Text(runningManager.formattedTime(runningManager.counter))
            .font(Font.custom("Pretendard-ExtraBold", size: 70))
            .foregroundColor(.customPrimary)
            .monospacedDigit()
            .minimumScaleFactor(0.5)
            .lineLimit(1)
    }
}

extension WorkoutDataView {
    private func workoutDataItem(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .foregroundColor(.white)
                .font(
                    Font.custom("Pretendard-SemiBold", size: 36)
                )
            Text(label)
                .font(Font.custom("Pretendard-Regular", size: 16))
                .foregroundColor(Color.gray500)
        }
    }
}

#Preview {
    WorkoutDataView()
}
