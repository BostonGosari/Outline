//
//  CategoryTestView.swift
//  Outline
//
//  Created by Seungui Moon on 11/19/23.
//

import SwiftUI
import Kingfisher

struct CategoryTestView: View {
    @StateObject private var categoryTestViewModel = CategoryTestViewModel()
    
    var body: some View {
        VStack {
            Text("categorized Couses")
                .font(.customTitle)
            
            Text(categoryTestViewModel.firstCategoryTitle)
                .font(.customTitle2)
            HStack {
                ForEach(categoryTestViewModel.firstCourseList, id: \.self) { course in
                    Text(course.courseName)
                    KFImage(URL(string: course.thumbnail))
                        .resizable()
                        .placeholder {
                            UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 45, bottomTrailingRadius: 45, topTrailingRadius: 70, style: .circular)
                                .foregroundColor(.gray700)
                        }
                }
            }
            Text(categoryTestViewModel.secondCategoryTitle)
                .font(.customTitle2)
            HStack {
                ForEach(categoryTestViewModel.secondCourseList, id: \.self) { course in
                    Text(course.courseName)
                    KFImage(URL(string: course.thumbnail))
                        .resizable()
                        .placeholder {
                            UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 45, bottomTrailingRadius: 45, topTrailingRadius: 70, style: .circular)
                                .foregroundColor(.gray700)
                        }

                }
            }
            Text(categoryTestViewModel.thirdCategoryTitle)
                .font(.customTitle2)
            HStack {
                ForEach(categoryTestViewModel.thirdCourseList, id: \.self) { course in
                    Text(course.courseName)
                    KFImage(URL(string: course.thumbnail))
                        .resizable()
                        .placeholder {
                            UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 45, bottomTrailingRadius: 45, topTrailingRadius: 70, style: .circular)
                                .foregroundColor(.gray700)
                        }
                }
            }
            
            Button {
                readCategories()
            } label: {
                Text("read id list")
            }
            
        }
    }
    
    private func readCategories() {
        categoryTestViewModel.readFirstCourseList()
        categoryTestViewModel.readSecondCourseList()
        categoryTestViewModel.readThirdCourseList()
    }
}

#Preview {
    CategoryTestView()
}
