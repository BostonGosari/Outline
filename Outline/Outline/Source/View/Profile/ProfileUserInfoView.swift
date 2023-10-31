//
//  ProfileUserInfoView.swift
//  Outline
//
//  Created by Seungui Moon on 10/31/23.
//

import SwiftUI

struct ProfileUserInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var userName = "아웃라인메이트"
    @State private var birthday = Date()
    @State private var gender: Gender = .notSetted

    @State private var showBirthdayPicker = false
    @State private var showGenderPicker = false
    
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
                Image("changeProfileImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 118, height: 118)
            }
            .padding(.top, 18)
            
            HStack {
                Text("문승의")
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 30)
            
            TextField("아웃라인메이트", text: $userName)
            .textFieldStyle(OvalTextFieldStyle())
            .padding(.horizontal, 16)
            
            Divider()
                .frame(height: 1)
                .background(Color.gray700)
                .padding(.vertical, 20)
            
            List {
                Group {
                    Button {
                        showBirthdayPicker.toggle()
                    } label: {
                        HStack {
                            Text("생년월일")
                            Spacer()
                            Text("2003.09.06.")
                                .foregroundStyle(Color.gray400)
                        }
                        .frame(height: 40)
                    }

                    Button {
                        showGenderPicker.toggle()
                    } label: {
                        HStack {
                            Text("성별")
                            Spacer()
                            Text("\(gender.rawValue)")
                                .foregroundStyle(Color.customPrimary)
                        }
                        .frame(height: 40)
                    }
                }
                .listRowBackground(Color.gray750)
                .listRowSeparator(.hidden)
            }
            .cornerRadius(10)
            .listStyle(.inset)
            .padding(.horizontal, 16)
            .frame(height: 2 * 62)
            
            Spacer()
        }
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.gray900)
        .sheet(isPresented: $showBirthdayPicker, content: {
            DatePicker(
                "생일",
                selection: $birthday,
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
                    // handle save data
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

#Preview {
    ProfileUserInfoView()
}
