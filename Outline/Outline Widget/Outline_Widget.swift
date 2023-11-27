////
////  Outline_Widget.swift
////  Outline Widget
////
////  Created by 김하은 on 11/26/23.
////
//
//import WidgetKit
//import SwiftUI
//import Intents
//
//@main
//struct RunningStatus: Widget {
//    var body: some WidgetConfiguration{
//        ActivityConfiguration(attributesType: RunningAttributes.self) { context in
//            ZStack{
//                RoundedRectangle(cornerRadius: 25,style: .continuous)
//                    .fill(Color.black.opacity(0.7))
//                
//                VStack{
//                    HStack{
//                        Text(context.state.totalTime)
//                            .font(Font.custom("Pretendard", size: 14))
//                            .multilineTextAlignment(.center)
//                            .foregroundColor(.white)
//                        Spacer()
//                        Ellipse()
//                        Text("OUTLINE RUNNING")
//                    }
//                    HStack{
//                        Text("0.81")
//                        Text("KM")
//                    }
//                    Divider()
//                    HStack{
//                        Text("10:03")
//                        Spacer()
//                        Text("3’33”")
//                        Spacer()
//                        Text("􀊴 127")
//                    }
//                }
//            }
//        }
//    }
//}
//                              
