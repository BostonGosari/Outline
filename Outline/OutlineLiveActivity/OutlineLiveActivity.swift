//
//  OutlineLiveActivity.swift
//  OutlineLiveActivity
//
//  Created by 김하은 on 11/29/23.
//
import SwiftUI
import WidgetKit
import Intents

struct OutlineLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: RunningAttributes.self) { context in
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .background(Color.customBlack.opacity(0.7))
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                        .inset(by: 0.5)
                        .stroke(Color.customPrimary, lineWidth: 1.5)
                    )
                VStack(spacing: 0) {
                    HStack {
                        Text("러닝중")
                            .foregroundStyle(.customWhite)
                            .font(.customCaption)
                        Spacer()
                        Image(systemName: "circle.fill")
                            .foregroundStyle(.customPrimary)
                        Text("OUTLINE RUNNING")
                            .foregroundStyle(.customPrimary)
                            .font(.customCaption)
                    }
                     
                    HStack(alignment: .bottom, spacing: 0) {
                        Text(context.state.totalDistance)
                            .font(.customWidgetTitle)
                        Text("KM")
                            .font(.customCaption)
                            .padding(.bottom, 5)
                        Spacer()
                    }
                    .foregroundStyle(.customPrimary)
                    .padding(.top, 15)
                    .padding(.bottom, 13)
                    
                    Divider()
                    HStack {
                        Text(context.state.totalTime)
                            .font(.customWidgetData)
                        Spacer()
                        Text(context.state.pace)
                            .font(.customWidgetData)
                        Spacer()
                        Image(systemName: "heart")
                            .font(.customCaption)
                        Text(context.state.heartrate)
                            .font(.customWidgetData)
                    }
                    
                    .fontWeight(.bold)
                    .foregroundStyle(.gray200)
                }
                .padding(EdgeInsets(top: 20, leading: 24, bottom: 10, trailing: 24))
            }
            
        } dynamicIsland: { context in
            DynamicIsland {
              
                DynamicIslandExpandedRegion(.leading) {
                 
                }
                DynamicIslandExpandedRegion(.trailing) {
                  
                }
                DynamicIslandExpandedRegion(.center) {
                   
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.state.totalTime)
                }
            } compactLeading: {
          
            } compactTrailing: {
            
            } minimal: {
           
            }
           
        }
       
    }
}
