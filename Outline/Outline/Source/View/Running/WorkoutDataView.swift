import SwiftUI

struct WorkoutDataView: View {
    
    @ObservedObject var runningViewModel: RunningViewModel
    @StateObject var digitalTimerViewModel: DigitalTimerViewModel
    let weight: Double = 60
    
    var body: some View {
        ZStack {
            Color("Gray900").ignoresSafeArea()
            VStack {
                DigitalTimerView(digitalTimerViewModel: digitalTimerViewModel)
                Spacer()
                LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 36) {
                    workoutDataItem(value: "\(runningViewModel.totalDistance + runningViewModel.distance)", label: "킬로미터")
                    workoutDataItem(value: "\((runningViewModel.totalTime + runningViewModel.time) / (runningViewModel.totalDistance + runningViewModel.distance) * 1000)", label: "평균 페이스")
                    workoutDataItem(value: "\(runningViewModel.kilocalorie)", label: "칼로리")
                    workoutDataItem(value: "--", label: "BPM")
                }
            }
            .onChange(of: runningViewModel.distance) { _, _ in
                runningViewModel.kilocalorie = weight * (runningViewModel.totalDistance + runningViewModel.distance) / 1000 * 1.036
            }
            .frame(height: 300)
            .padding()
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

struct WorkoutDataView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutDataView(runningViewModel: RunningViewModel(), digitalTimerViewModel: DigitalTimerViewModel())
    }
}
