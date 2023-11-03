import SwiftUI

struct WorkoutDataView: View {
    @StateObject var runningManager = RunningStartManager.shared
    @StateObject var runningDataManager = RunningDataManager.shared
    
    @Binding var selection: Bool
    
    private let weight: Double = 60
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                digitalTimer
                    .padding(.top, 120)
                    .padding(.bottom, 42)
                
                workOutDataGrid
                    .padding(.bottom, 98)
                    .padding(.horizontal, 32)
                
                Button {
                    withAnimation {
                        selection.toggle()
                    }
                } label: {
                    Image(systemName: "map.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.customBlack)
                        .frame(width: 60, height: 60)
                        .background(
                            Circle()
                                .fill(Color.customPrimary)
                        )
                }
                .padding(.trailing, 16)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .onChange(of: runningDataManager.distance) { _, _ in
                runningDataManager.kilocalorie = weight * (runningDataManager.totalDistance + runningDataManager.distance) / 1000 * 1.036
            }
        }
    }
    
    private var workOutDataGrid: some View {
        VStack(spacing: 39) {
            let totalTime = runningDataManager.totalTime + runningDataManager.time
            let totalDistance = runningDataManager.totalDistance + runningDataManager.distance
            let averagePace = totalTime / totalDistance * 1000
            
            let distanceKM = totalDistance / 1000
            let kilocalorie = runningDataManager.kilocalorie
            let cadence = totalTime != 0 ? ((runningDataManager.totalSteps + runningDataManager.steps) / totalTime * 60) : 0
            HStack {
                workoutDataItem(value: String(format: "%.2f", distanceKM), label: "킬로미터")
                workoutDataItem(value: "--", label: "BPM")
                workoutDataItem(value: String(format: "%.0f", kilocalorie), label: "칼로리")
            }
            HStack {
                workoutDataItem(value: String(format: "%.0f", cadence), label: "케이던스")
                VStack(spacing: 4) {
                    Text(averagePace.formattedAveragePace())
                        .foregroundColor(.white)
                        .font(
                            Font.custom("Pretendard-SemiBold", size: 32)
                        )
                        .scaleEffect(averagePace > 600 ? (averagePace > 6000 ? 0.7 : 0.9) : 1.0)
                    Text("평균 페이스")
                        .font(Font.custom("Pretendard-Regular", size: 16))
                        .foregroundColor(Color.gray200)
                }
                .frame(maxWidth: .infinity)
                workoutDataItem(value: "", label: "")
            }
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
                    Font.custom("Pretendard-SemiBold", size: 32)
                )
            Text(label)
                .font(Font.custom("Pretendard-Regular", size: 16))
                .foregroundColor(Color.gray200)
        }
        .frame(maxWidth: .infinity)
    }
}
