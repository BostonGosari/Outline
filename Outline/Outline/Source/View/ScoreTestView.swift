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
    @State private var savedScore: Int = 0
    
    var body: some View {
        VStack {
            Text("\(savedScore)")
            ForEach(courseScores, id: \.id) { courseScore in
                HStack {
                    Text("\(courseScore.courseId ?? "no id")")
                        .onTapGesture {
                            if let courseId = courseScore.courseId {
                                courseScoreModel.getScore(id: courseId) { result in
                                    switch result {
                                    case .success(let score):
                                        self.savedScore = score
                                    case .failure(let failure):
                                        print("fail to get score \(failure)")
                                    }
                                }
                            }
                        }
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
