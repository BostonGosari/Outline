//
//  ScoreTestView.swift
//  Outline
//
//  Created by Seungui Moon on 11/20/23.
//

import SwiftUI

struct ScoreTestView: View {
    @FetchRequest (entity: CoreCourseScore.entity(), sortDescriptors: []) var courseScores: FetchedResults<CoreCourseScore>
    private let courseScoreModel = CourseScoreModel()
    @State private var score: String = ""
    
    var body: some View {
        VStack {
            ForEach(courseScores, id: \.id) { courseScore in
                Text("\(courseScore.score)")
                    .onTapGesture {
                        courseScoreModel.deleteScore(courseScore) { res in
                            switch res {
                            case .success(let success):
                                print("success to delete score \(success)")
                            case .failure(let failure):
                                print("fail to delete score \(failure)")
                            }
                        }
                    }
            }
            TextField("score", text: $score)
            
            Button {
                courseScoreModel.createScore(courseId: UUID().uuidString, score: Int(score) ?? 0) { res in
                    switch res {
                    case .success(let success):
                        print("success to create score \(success)")
                    case .failure(let failure):
                        print("fail to create score \(failure)")
                    }
                }
            } label: {
                Text("create score")
            }
        }
    }
}

#Preview {
    ScoreTestView()
}
