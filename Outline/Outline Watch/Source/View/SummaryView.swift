//
//  SummaryView.swift
//  Outline Watch App
//
//  Created by 김하은 on 10/17/23.
//

import Foundation
import HealthKit
import SwiftUI
import WatchKit

struct SummaryView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var workoutManager = WatchWorkoutManager.shared
    @StateObject var runningManager = WatchRunningManager.shared
    
    @State private var isShowingFinishView = true
    @State private var timeFormatter = ElapsedTimeFormatter()
    @State private var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    @State private var progress = 0.0
    
    @Namespace var topID
    
    var body: some View {
        if isShowingFinishView {
            FinishWatchView(completionPercentage: 100)
                .onAppear {
                   scheduleTimerToHideFinishView()
                }
        } else {
            ScrollViewReader { proxy in
                ScrollView {
                    PathGenerateManager.caculateLines(width: 80, height: 80, coordinates: runningManager.userLocations)
//                    TestShape()
                        .trim(from: 0, to: progress)
                        .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                        .scaledToFit()
                        .foregroundStyle(.first)
                        .frame(width: 120, height: 120)
                        .onAppear {
                            progress = 1.0
                        }
                        .animation(.bouncy(duration: 3), value: progress)
                    ConfettiWatchView()
                    Text("그림을 완성했어요!")
                        .padding(.vertical)
                    Text(NSNumber(value: workoutManager.builder?.elapsedTime ?? 0), formatter: timeFormatter)
                        .id(topID)
                        .foregroundColor(Color.first)
                        .font(.system(size: 40, weight: .bold))
                      
                    Text("총시간")
                        .font(.system(size: 14))
                        .foregroundColor(Color.gray500)
                        .padding(.bottom, 24)
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 24) {
                        workoutDataItem(value: "\((workoutManager.distance/1000).formatted(.number.precision(.fractionLength(2))))", label: "킬로미터")
                        workoutDataItem(value: workoutManager.averagePace > 0
                                        ? workoutManager.averagePace.formattedAveragePace() : "-’--’’",
                                        label: "평균 페이스")
                        workoutDataItem(value: "\(workoutManager.calorie.formatted(.number.precision(.fractionLength(0))))", label: "칼로리")
                        workoutDataItem(value: "\(workoutManager.averageHeartRate.formatted(.number.precision(.fractionLength(0))))", label: "BPM")
                    }
                    .padding(.bottom, 36)
                    Spacer()
                    Text("Outline 앱에서 전체 활동 기록을 확인하세요.")
                        .font(.system(size: 10))
                        .foregroundColor(Color.gray500)
                        .padding(.bottom, 8)
                    Button {
                        runningManager.startRunning = false
                        workoutManager.resetWorkout()
                        dismiss()
                    } label: {
                        Text("완료")
                    }
                    .frame(maxWidth: .infinity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.easeInOut(duration: 2)) {
                                proxy.scrollTo(topID, anchor: .top)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func scheduleTimerToHideFinishView() {
           Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
               withAnimation {
                   isShowingFinishView = false
               }
           }
    }
}

extension SummaryView {
    private func workoutDataItem(value: String, label: String) -> some View {
        VStack(spacing: 0) {
            Text(value)
                .foregroundColor(.white)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(Color.gray500)
        }
    }
}

struct TestShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.85156*width, y: 0.15999*height))
        path.addCurve(to: CGPoint(x: 0.68629*width, y: 0.03412*height), control1: CGPoint(x: 0.84925*width, y: 0.07495*height), control2: CGPoint(x: 0.75353*width, y: 0.04769*height))
        path.addCurve(to: CGPoint(x: 0.52778*width, y: 0.02382*height), control1: CGPoint(x: 0.63352*width, y: 0.02347*height), control2: CGPoint(x: 0.58137*width, y: 0.02382*height))
        path.addCurve(to: CGPoint(x: 0.38651*width, y: 0.03396*height), control1: CGPoint(x: 0.47978*width, y: 0.02382*height), control2: CGPoint(x: 0.43358*width, y: 0.02323*height))
        path.addCurve(to: CGPoint(x: 0.17211*width, y: 0.13102*height), control1: CGPoint(x: 0.31223*width, y: 0.05089*height), control2: CGPoint(x: 0.22638*width, y: 0.07431*height))
        path.addCurve(to: CGPoint(x: 0.0774*width, y: 0.34446*height), control1: CGPoint(x: 0.116*width, y: 0.18966*height), control2: CGPoint(x: 0.07646*width, y: 0.26279*height))
        path.addCurve(to: CGPoint(x: 0.11364*width, y: 0.46856*height), control1: CGPoint(x: 0.07789*width, y: 0.38761*height), control2: CGPoint(x: 0.09814*width, y: 0.42897*height))
        path.addCurve(to: CGPoint(x: 0.11219*width, y: 0.53069*height), control1: CGPoint(x: 0.12246*width, y: 0.49107*height), control2: CGPoint(x: 0.12362*width, y: 0.50949*height))
        path.addCurve(to: CGPoint(x: 0.02537*width, y: 0.69584*height), control1: CGPoint(x: 0.08389*width, y: 0.58321*height), control2: CGPoint(x: 0.0291*width, y: 0.63245*height))
        path.addCurve(to: CGPoint(x: 0.04422*width, y: 0.82381*height), control1: CGPoint(x: 0.02277*width, y: 0.74001*height), control2: CGPoint(x: 0.0205*width, y: 0.78502*height))
        path.addCurve(to: CGPoint(x: 0.108*width, y: 0.87274*height), control1: CGPoint(x: 0.05844*width, y: 0.84706*height), control2: CGPoint(x: 0.07863*width, y: 0.87119*height))
        path.addCurve(to: CGPoint(x: 0.13861*width, y: 0.87563*height), control1: CGPoint(x: 0.11833*width, y: 0.87329*height), control2: CGPoint(x: 0.12809*width, y: 0.87563*height))
        path.addCurve(to: CGPoint(x: 0.17437*width, y: 0.8634*height), control1: CGPoint(x: 0.15439*width, y: 0.87563*height), control2: CGPoint(x: 0.16073*width, y: 0.87035*height))
        path.addCurve(to: CGPoint(x: 0.23687*width, y: 0.82348*height), control1: CGPoint(x: 0.19581*width, y: 0.85248*height), control2: CGPoint(x: 0.21956*width, y: 0.84079*height))
        path.addCurve(to: CGPoint(x: 0.29486*width, y: 0.74397*height), control1: CGPoint(x: 0.26229*width, y: 0.79808*height), control2: CGPoint(x: 0.27665*width, y: 0.7758*height))
        path.addCurve(to: CGPoint(x: 0.34061*width, y: 0.69375*height), control1: CGPoint(x: 0.2986*width, y: 0.73742*height), control2: CGPoint(x: 0.33004*width, y: 0.68436*height))
        path.addCurve(to: CGPoint(x: 0.32256*width, y: 0.77262*height), control1: CGPoint(x: 0.35205*width, y: 0.70391*height), control2: CGPoint(x: 0.32691*width, y: 0.76004*height))
        path.addCurve(to: CGPoint(x: 0.23397*width, y: 0.87628*height), control1: CGPoint(x: 0.30791*width, y: 0.815*height), control2: CGPoint(x: 0.26633*width, y: 0.84732*height))
        path.addCurve(to: CGPoint(x: 0.15278*width, y: 0.92489*height), control1: CGPoint(x: 0.20887*width, y: 0.89874*height), control2: CGPoint(x: 0.18702*width, y: 0.91867*height))
        path.addCurve(to: CGPoint(x: 0.09463*width, y: 0.92055*height), control1: CGPoint(x: 0.14246*width, y: 0.92677*height), control2: CGPoint(x: 0.09808*width, y: 0.93606*height))
        path.addCurve(to: CGPoint(x: 0.09061*width, y: 0.91056*height), control1: CGPoint(x: 0.09414*width, y: 0.91834*height), control2: CGPoint(x: 0.08787*width, y: 0.91135*height))
        path.addCurve(to: CGPoint(x: 0.1022*width, y: 0.92135*height), control1: CGPoint(x: 0.0955*width, y: 0.90917*height), control2: CGPoint(x: 0.10022*width, y: 0.91832*height))
        path.addCurve(to: CGPoint(x: 0.25169*width, y: 0.97286*height), control1: CGPoint(x: 0.13151*width, y: 0.96604*height), control2: CGPoint(x: 0.2007*width, y: 0.98431*height))
        path.addCurve(to: CGPoint(x: 0.33803*width, y: 0.92683*height), control1: CGPoint(x: 0.28522*width, y: 0.96533*height), control2: CGPoint(x: 0.31055*width, y: 0.94602*height))
        path.addCurve(to: CGPoint(x: 0.39956*width, y: 0.86823*height), control1: CGPoint(x: 0.36172*width, y: 0.91027*height), control2: CGPoint(x: 0.38261*width, y: 0.89175*height))
        path.addCurve(to: CGPoint(x: 0.44708*width, y: 0.80755*height), control1: CGPoint(x: 0.41432*width, y: 0.84775*height), control2: CGPoint(x: 0.42915*width, y: 0.82547*height))
        path.addCurve(to: CGPoint(x: 0.45787*width, y: 0.78936*height), control1: CGPoint(x: 0.452*width, y: 0.80263*height), control2: CGPoint(x: 0.45257*width, y: 0.7936*height))
        path.addCurve(to: CGPoint(x: 0.47913*width, y: 0.81785*height), control1: CGPoint(x: 0.46166*width, y: 0.78633*height), control2: CGPoint(x: 0.47715*width, y: 0.81502*height))
        path.addCurve(to: CGPoint(x: 0.5281*width, y: 0.86984*height), control1: CGPoint(x: 0.49253*width, y: 0.83697*height), control2: CGPoint(x: 0.50682*width, y: 0.85867*height))
        path.addCurve(to: CGPoint(x: 0.63071*width, y: 0.91878*height), control1: CGPoint(x: 0.56133*width, y: 0.88729*height), control2: CGPoint(x: 0.59634*width, y: 0.90367*height))
        path.addCurve(to: CGPoint(x: 0.78583*width, y: 0.93841*height), control1: CGPoint(x: 0.6781*width, y: 0.93961*height), control2: CGPoint(x: 0.73571*width, y: 0.95958*height))
        path.addCurve(to: CGPoint(x: 0.92726*width, y: 0.78002*height), control1: CGPoint(x: 0.85691*width, y: 0.9084*height), control2: CGPoint(x: 0.8978*width, y: 0.84926*height))
        path.addCurve(to: CGPoint(x: 0.97607*width, y: 0.5624*height), control1: CGPoint(x: 0.95642*width, y: 0.71149*height), control2: CGPoint(x: 0.9736*width, y: 0.63669*height))
        path.addCurve(to: CGPoint(x: 0.91421*width, y: 0.36313*height), control1: CGPoint(x: 0.97853*width, y: 0.48872*height), control2: CGPoint(x: 0.94256*width, y: 0.4285*height))
        path.addCurve(to: CGPoint(x: 0.88925*width, y: 0.23886*height), control1: CGPoint(x: 0.89641*width, y: 0.32207*height), control2: CGPoint(x: 0.89252*width, y: 0.28289*height))
        path.addCurve(to: CGPoint(x: 0.8696*width, y: 0.19476*height), control1: CGPoint(x: 0.88826*width, y: 0.22561*height), control2: CGPoint(x: 0.87558*width, y: 0.20672*height))
        path.addCurve(to: CGPoint(x: 0.8588*width, y: 0.17737*height), control1: CGPoint(x: 0.86637*width, y: 0.1883*height), control2: CGPoint(x: 0.8613*width, y: 0.18436*height))
        path.addCurve(to: CGPoint(x: 0.85445*width, y: 0.1542*height), control1: CGPoint(x: 0.85613*width, y: 0.16991*height), control2: CGPoint(x: 0.857*width, y: 0.16182*height))
        return path
    }
}
