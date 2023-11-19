//
//  CategoryTestView.swift
//  Outline
//
//  Created by Seungui Moon on 11/19/23.
//

import SwiftUI

struct CategoryTestView: View {
    private let courseModel = CourseModel()
    @State private var courseCategories: CourseCategories = []
    
    var body: some View {
        VStack {
            Text("categorized Couses")
            Button {
                readCategories()
            } label: {
                Text("read id list")
            }
            ForEach(courseCategories, id: \.self) { category in
                Text(category.title)
                HStack {
                    ForEach(category.courseIdList, id: \.self) { courseId in
                        Text("\(courseId)")
                    }
                }
            }
        }
    }
    
    private func readCategories() {
        courseModel.readCategory(categoryType: .category1) { res in
            switch res {
            case .success(let courseCategory):
                self.courseCategories.append(courseCategory)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

#Preview {
    CategoryTestView()
}
