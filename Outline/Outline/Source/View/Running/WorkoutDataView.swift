import SwiftUI

struct WorkoutDataView: View {
    
    @ObservedObject var runningViewModel: RunningViewModel
    @ObservedObject var digitalTimerViewModel: DigitalTimerViewModel
    let weight: Double = 60
    
    var body: some View {
        ZStack {
            Color("Gray900").ignoresSafeArea()
            VStack {
                DigitalTimerView(digitalTimerViewModel: digitalTimerViewModel)
                Spacer()
                workOutDataGrid
            }
            .onChange(of: runningViewModel.distance) { _, _ in
                runningViewModel.kilocalorie = weight * (runningViewModel.totalDistance + runningViewModel.distance) / 1000 * 1.036
            }
            .frame(height: 300)
            .padding()
        }
    }
    
    private var workOutDataGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 36) {
            let averagePace = (runningViewModel.totalTime + runningViewModel.time) / (runningViewModel.totalDistance + runningViewModel.distance) * 1000
            
            workoutDataItem(value: String(format: "%.2f", (runningViewModel.totalDistance + runningViewModel.distance) / 1000), label: "킬로미터")
            workoutDataItem(value: averagePace.formattedAveragePace(), label: "평균 페이스")
            workoutDataItem(value: String(format: "%.0f", runningViewModel.kilocalorie), label: "칼로리")
            workoutDataItem(value: "--", label: "BPM")
        }
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

// MARK: - Double Extension 페이스를 표시하기 위한 함수
extension Double {
    /// 초단위의 Double 을 페이스 형식으로 바꿔주는 Extension
    /// - Returns: -'--'' 형식의 String
    func formattedAveragePace() -> String {
        if self.isNaN {
            return "-'--''"
        }
        let minutes = Int(self / 60)
        let seconds = Int(self) % 60
        return String(format: "%02d'%02d''", minutes, seconds)
    }
}

#Preview {
    WorkoutDataView(runningViewModel: RunningViewModel(homeTabViewModel: HomeTabViewModel()), digitalTimerViewModel: DigitalTimerViewModel())
}
