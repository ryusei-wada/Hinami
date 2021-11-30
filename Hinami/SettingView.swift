//
//  SettingView.swift
//  Hinami
//
//  Created by Ryusei Wada on 2021/11/27.
//

import SwiftUI
import UserNotifications

class Flags: ObservableObject {
    
    var showAlert = false
    @Published var rFlag = false {
        didSet {
            showAlert = (!NotificationController().isNotificationPermission() && (sFlag || rFlag || eFlag))
            print("set rFlag!:\(rFlag)")
        }
    }
    @Published var eFlag = false {
        didSet {
            showAlert = (!NotificationController().isNotificationPermission() && (sFlag || rFlag || eFlag))
            print("set eFlag!:\(eFlag)")
        }
    }
    @Published var sFlag = false{
        didSet {
            showAlert = (!NotificationController().isNotificationPermission() && (sFlag || rFlag || eFlag))
            print("set sFlag!:\(sFlag)")
        }
    }
}

struct SettingView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var restAlertFlag: Bool
    @Binding var supplyAlertFlag: Bool
    @Binding var endOfRestAlertFlag: Bool
    @Binding var restInterval: Int
    @Binding var restTime: Int
    @Binding var supplyInterval: Int
    @Binding var statusController: StatusController
    
    var accumulatedTime: TimeStruct
    
    let openSettingTime = Date()
    
    @State var rIntervalTmp = 0
    @State var rTimeTmp = 0
    @State var sIntervalTmp = 0
    
    @ObservedObject var flags = Flags()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle(isOn: $flags.rFlag) {
                        Text("休憩通知")
                    }
                    .alert("通知が許可されていません", isPresented: $flags.showAlert) {
                        Button("OK") {
                            flags.rFlag = false
                            flags.sFlag = false
                            flags.eFlag = false
                        }
                    } message: {
                        Text("「設定>Hinami>通知」から通知を許可してください")
                    }
                    
                    if (flags.rFlag) {
                        Picker(selection: $rIntervalTmp) {
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
                    Toggle(isOn: $flags.eFlag) {
                        Text("休憩終了通知")
                    }
                    .alert("通知が許可されていません", isPresented: $flags.showAlert) {
                        Button("OK") {
                            flags.rFlag = false
                            flags.sFlag = false
                            flags.eFlag = false
                        }
                    } message: {
                        Text("「設定>Hinami>通知」から通知を許可してください")
                    }
                    
                    if (flags.eFlag) {
                        Picker(selection: $rTimeTmp) {
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
                    Toggle(isOn: $flags.sFlag) {
                        Text("給水通知")
                    }
                    .alert("通知が許可されていません", isPresented: $flags.showAlert) {
                        Button("OK") {
                            flags.rFlag = false
                            flags.sFlag = false
                            flags.eFlag = false
                        }
                    } message: {
                        Text("「設定>Hinami>通知」から通知を許可してください")
                    }
                    
                    if (flags.sFlag) {
                        Picker(selection: $sIntervalTmp) {
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
                        let diff = Calendar(identifier: .gregorian).dateComponents([.second], from: openSettingTime, to: Date())
                        let currentTimeVal = (accumulatedTime.getH()*60*60)+(accumulatedTime.getM()*60)+(accumulatedTime.getS())
                        + (diff.second ?? 0)
                        
                        let status = statusController.getStatusType()
                        switch status {
                        case .takingBreak:
                            if flags.eFlag {
                                if currentTimeVal < rTimeTmp {
                                    NotificationController().makeEndOfRestNotification(interval: rTimeTmp-currentTimeVal,  labelTime: rTimeTmp)
                                }
                            } else {
                                NotificationController().removeEndOfRestNotification()
                            }
                            
                            if flags.sFlag {
                                if currentTimeVal < sIntervalTmp {
                                    NotificationController().makeSupplyNotification(interval: sIntervalTmp-currentTimeVal, labelTime: sIntervalTmp)
                                }
                            }else {
                                NotificationController().removeSupplyNotification()
                            }
                            
                            if !flags.rFlag {
                                NotificationController().removeRestNotification()
                            }
                            
                            break
                        case .working:
                            if flags.rFlag {
                                if currentTimeVal < rIntervalTmp {
                                    NotificationController().makeRestNotification(interval: rIntervalTmp-currentTimeVal, labelTime: rIntervalTmp)
                                }
                            } else {
                                NotificationController().removeRestNotification()
                            }
                            
                            if flags.sFlag {
                                if currentTimeVal < sIntervalTmp {
                                    NotificationController().makeSupplyNotification(interval: sIntervalTmp-currentTimeVal, labelTime: sIntervalTmp)
                                }
                            } else {
                                NotificationController().removeSupplyNotification()
                            }
                            
                            if !flags.eFlag {
                                NotificationController().removeEndOfRestNotification()
                            }
                            
                            break
                        default:
                            break
                        }
                        restAlertFlag = flags.rFlag
                        endOfRestAlertFlag = flags.eFlag
                        supplyAlertFlag = flags.sFlag
                        restInterval = rIntervalTmp
                        restTime = rTimeTmp
                        supplyInterval = sIntervalTmp
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("確定")
                    }
                }
            }
            .navigationTitle("Setting")
            
        }
        .onAppear {
            flags.sFlag = supplyAlertFlag
            flags.eFlag = endOfRestAlertFlag
            flags.rFlag = restAlertFlag
            rIntervalTmp = restInterval
            rTimeTmp = restTime
            sIntervalTmp = supplyInterval
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
            statusController: .constant(StatusController(status: .offDuty)),
            accumulatedTime: TimeStruct()
        )
    }
}
