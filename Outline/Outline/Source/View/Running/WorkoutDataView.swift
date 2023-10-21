import SwiftUI

struct WorkoutDataView: View {
    
    @ObservedObject var runningViewModel: RunningViewModel
    let weight: Double = 60

    var body: some View {
        ZStack {
            Color("Gray900").ignoresSafeArea()
            VStack {
                strokeText(text: "\(runningViewModel.distance)", width: 2, color: Color.primaryColor)
                    .font(
                        Font.custom("Pretendard-ExtraBold", size: 64)
                    )
                Spacer()
                LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 36) {
                    workoutDataItem(value: "\(runningViewModel.distance)", label: "킬로미터")
                    workoutDataItem(value: "\(runningViewModel.avgPace / 60 * 1000)", label: "평균 페이스")
                    workoutDataItem(value: "\(runningViewModel.kilocalorie)", label: "칼로리")
                    workoutDataItem(value: "--", label: "BPM")
                }
            }
            .frame(height: 300)
            .padding()
            .onChange(of: runningViewModel.distance) { _, distance in
                runningViewModel.kilocalorie = weight * distance / 1000 * 1.036
            }
        }
    }
}

extension WorkoutDataView {
    private func strokeText(text: String, width: CGFloat, color: Color) -> some View {
        ZStack {
            ZStack {
                Text(text).offset(x: width, y: width)
                Text(text).offset(x: -width, y: -width)
                Text(text).offset(x: -width, y: width)
                Text(text).offset(x: width, y: -width)
            }
            .foregroundColor(color)
            Text(text)
                .foregroundColor(Color("Gray900"))
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
        WorkoutDataView(runningViewModel: RunningViewModel())
    }
}
