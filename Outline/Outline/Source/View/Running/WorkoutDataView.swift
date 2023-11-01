import SwiftUI

struct WorkoutDataView: View {
    @StateObject var runningManager = RunningStartManager.shared
    @StateObject var runningDataManager = RunningDataManager.shared
    
    @Binding var selection: Int
    
    private let weight: Double = 60
    
    var body: some View {
        ZStack {
            Color("Gray900").ignoresSafeArea()
            VStack(spacing: 0) {
                digitalTimer
                    .padding(.top, 120)
                    .padding(.bottom, 42)
                
                workOutDataGrid
                    .padding(.bottom, 98)
                    .padding(.horizontal, 32)
                
                Button {
                    withAnimation {
                        selection = 0
                    }
                } label: {
                    Image(systemName: "map.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.customBlack)
                        .padding(16)
                        .background(
                            Circle()
                                .fill(Color.customPrimary)
                        )
                }
                .padding(.trailing, 32)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .onChange(of: runningDataManager.distance) { _, _ in
                runningDataManager.kilocalorie = weight * (runningDataManager.totalDistance + runningDataManager.distance) / 1000 * 1.036
            }
        }
    }
    
    private var workOutDataGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 50) {
            let averagePace = (runningDataManager.totalTime + runningDataManager.time) / (runningDataManager.totalDistance + runningDataManager.distance) * 1000
            
            workoutDataItem(value: String(format: "%.2f", (runningDataManager.totalDistance + runningDataManager.distance) / 1000), label: "킬로미터")
            workoutDataItem(value: "--", label: "BPM")
            workoutDataItem(value: averagePace.formattedAveragePace(), label: "평균 페이스")
            workoutDataItem(value: String(format: "%.0f", runningDataManager.kilocalorie), label: "칼로리")
            workoutDataItem(value: String(format: "%.0f", runningDataManager.cadence), label: "케이던스")
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
