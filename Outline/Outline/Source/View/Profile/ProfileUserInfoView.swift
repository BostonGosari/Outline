//
//  ProfileUserInfoView.swift
//  Outline
//
//  Created by Seungui Moon on 10/31/23.
//

import SwiftUI

struct ProfileUserInfoView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var nickname: String
    @Binding var birthday: Date
    @Binding var gender: Gender
    
    @State private var showBirthdayPicker = false
    @State private var showGenderPicker = false
    
    var completion: () -> Void
    
    private var dateRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .year, value: -120, to: Date())!
        let max = Calendar.current.date(byAdding: .year, value: 0, to: Date())!
        return min...max
    }
    
    var body: some View {
        VStack {
            ZStack {
                Image("defaultProfileImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 118, height: 118)
            }
            .padding(.top, 18)
            
            HStack {
                Text("닉네임")
                    .font(.subBody)
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 30)
            
            HStack {
                Text(nickname)
                    .font(.subBody)
                    .foregroundStyle(.gray400)
                Spacer()
            }
            .padding(12)
            .background(Color.gray750)
            .cornerRadius(10)
            .padding(.horizontal, 16)
            
            Divider()
                .frame(height: 1)
                .background(Color.gray700)
                .padding(.vertical, 20)
            
            List {
                Group {
                    HStack {
                        Text("생년월일")
                            .font(.subBody)
                        Spacer()
                        Text(birthday.dateToShareString())
                            .font(.subBody)
                            .foregroundStyle(Color.gray400)
                    }
                    .frame(height: 40)

                    HStack {
                        Text("성별")
                            .font(.subBody)
                        Spacer()
                        Text("\(gender.rawValue)")
                            .font(.subBody)
                            .foregroundStyle(Color.customPrimary)
                    }
                    .frame(height: 40)
                    
                }
                .listRowBackground(Color.gray750)
            }
            .cornerRadius(10)
            .listStyle(.inset)
            .padding(.horizontal, 16)
            .frame(height: 2 * 62)
            
            Spacer()
        }
        .navigationTitle("내 정보")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.gray900)
        .sheet(isPresented: $showBirthdayPicker, content: {
            DatePicker(
                "", selection: $birthday,
                in: dateRange,
                displayedComponents: [.date]
            )
            .datePickerStyle(.wheel)
            .presentationDetents([.medium])
        })
        .sheet(isPresented: $showGenderPicker, content: {
            Picker("성별", selection: $gender) {
                ForEach(Gender.allCases, id: \.self) { gender in
                    Text(gender.rawValue)
                }
            }
            .pickerStyle(.wheel)
            .presentationDetents([.medium])
        })
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    completion()
                    dismiss()
                } label: {
                    Text("완료")
                        .foregroundStyle(Color.customPrimary)
                }
            }
        }
    }
}

struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .background(Color.gray750)
            .cornerRadius(10)
    }
}
