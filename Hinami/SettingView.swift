//
//  SettingView.swift
//  Hinami
//
//  Created by Ryusei Wada on 2021/11/27.
//

import SwiftUI
import UserNotifications

struct SettingView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var restAlertFlag: Bool
    @Binding var supplyAlertFlag: Bool
    @Binding var endOfRestAlertFlag: Bool
    @Binding var restInterval: Int
    @Binding var restTime: Int
    @Binding var supplyInterval: Int
    @Binding var currentTime: TimeStruct
    @Binding var statusController: StatusController
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle(isOn: $restAlertFlag) {
                        Text("休憩通知")
                    }
                    
                    if (restAlertFlag) {
                        Picker(selection: $restInterval) {
                            Text("10 min")
                                .tag(10)
                            Text("20 min")
                                .tag(20)
                            Text("30 min")
                                .tag(30)
                            Text("45 min")
                                .tag(45)
                            Text("60 min")
                                .tag(60)
                            Text("90 min")
                                .tag(90)
                            Text("120 min")
                                .tag(120)
                        } label: {
                            Text("休憩通知までの時間")
                        }
                    }
                } header: {
                    Text("休憩通知設定")
                }
                
                Section {
                    Toggle(isOn: $endOfRestAlertFlag) {
                        Text("休憩終了通知")
                    }
                    
                    if (endOfRestAlertFlag) {
                        Picker(selection: $restTime) {
                            Text("5 min")
                                .tag(5)
                            Text("10 min")
                                .tag(10)
                            Text("15 min")
                                .tag(15)
                            Text("20 min")
                                .tag(20)
                            Text("25 min")
                                .tag(25)
                            Text("30 min")
                                .tag(30)
                            Text("45 min")
                                .tag(45)
                            Text("60 min")
                                .tag(60)
                        } label: {
                            Text("休憩終了通知までの時間")
                        }
                    }
                    
                } header: {
                    Text("休憩終了通知設定")
                }
                
                Section {
                    Toggle(isOn: $supplyAlertFlag) {
                        Text("給水通知")
                    }
                    
                    if (supplyAlertFlag) {
                        Picker(selection: $supplyInterval) {
                            Text("30 min")
                                .tag(30)
                            Text("45 min")
                                .tag(45)
                            Text("60 min")
                                .tag(60)
                            Text("90 min")
                                .tag(90)
                            Text("120 min")
                                .tag(120)
                        } label: {
                            Text("給水通知までの時間")
                        }
                    }
                } header: {
                    Text("給水通知設定（Beta）")
                }
                
                Section{
                    Button(action:{
                        let currentTimeVal = (currentTime.getH()*60*60)+(currentTime.getM()*60)+(currentTime.getS())
                        
                        let status = statusController.getStatusType()
                        switch status {
                        case .takingBreak:
                            if endOfRestAlertFlag {
                                if currentTimeVal < restTime {
                                    NotificationController().makeEndOfRestNotification(interval: restTime-currentTimeVal,  labelTime: restTime)
                                }
                            }
                            if supplyAlertFlag {
                                if currentTimeVal < supplyInterval {
                                    NotificationController().makeSupplyNotification(interval: supplyInterval-currentTimeVal, labelTime: supplyInterval)
                                }
                            }
                            break
                        case .working:
                            if restAlertFlag {
                                if currentTimeVal < restInterval {
                                    NotificationController().makeRestNotification(interval: restInterval-currentTimeVal, labelTime: restInterval)
                                }
                            }
                            if supplyAlertFlag {
                                if currentTimeVal < supplyInterval {
                                    NotificationController().makeSupplyNotification(interval: supplyInterval-currentTimeVal, labelTime: supplyInterval)
                                }
                            }
                            break
                        default:
                            break
                        }
                        
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("確定")
                    }
                }
            }
            .navigationTitle("Setting")
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(
            restAlertFlag: .constant(false),
            supplyAlertFlag: .constant(false),
            endOfRestAlertFlag: .constant(false),
            restInterval: .constant(45),
            restTime: .constant(15),
            supplyInterval: .constant(60),
            currentTime: .constant(TimeStruct()),
            statusController: .constant(StatusController(status: .offDuty))
        )
    }
}
