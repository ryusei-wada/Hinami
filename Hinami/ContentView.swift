//
//  ContentView.swift
//  Hinami
//
//  Created by Ryusei Wada on 2021/11/25.
//

import SwiftUI
import UserNotifications
import CoreData

/**
 時間の情報を管理するための構造体
 */
struct TimeStruct {
    private var h = 0
    private var m = 0
    private var s = 0
    
    init() {}
    
    init(h:Int,m:Int,s:Int) {
        self.h = h
        self.m = m
        self.s = s
    }
    
    /**
     引数で渡した値を時刻情報のプロパティとしてセットする関数
     */
    mutating func setTime(h: Int, m: Int, s: Int) {
        self.h = h
        self.m = m
        self.s = s
    }
    
    /**
     時刻情報のプロパティをリセットする関数
     */
    mutating func resetTime() {
        h = 0
        m = 0
        s = 0
    }
    
    /**
     時刻情報のうち、時間の値をreturnする関数
     */
    func getH() -> Int {
        return h
    }
    
    /**
     時刻情報のうち、分の値をreturnする関数
     */
    func getM() -> Int {
        return m
    }
    
    /**
     時刻情報のうち、秒の値をreturnする関数
     */
    func getS() -> Int {
        return s
    }
    
    /**
     時刻情報を"HH:mm:ss"という文字列としてreturnする
     */
    func getTimeStr() -> String {
        return "\(String(format:"%02d", h)):\(String(format:"%02d", m)):\(String(format:"%02d", s))"
    }
}


struct ContentView: View {
//    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var isPressed = Array(repeating: false, count: 3)
    @State private var statusController = StatusController(status: .offDuty)
    @State private var isSettigViewActive = false
    
    @AppStorage("restAlertFlag") private var restAlertFlag = false
    @AppStorage("endOfRestAlertFlag") private var endOfRestAlertFlag = false
    @AppStorage("supplyAlertFlag") private var supplyAlertFlag = false
    @AppStorage("restInterval") private var restInterval = 45
    @AppStorage("restTime") private var restTime = 15
    @AppStorage("supplyInterval") private var supplyInterval = 60
    
    @State private var workTime = TimeStruct()
    @State private var currentTime = TimeStruct()
    
    @State private var timerHandler: Timer?
    
    @State private var timerStartDate = ""
    @State private var timerStopDate = ""
    @State private var workTimerStartDate = ""
    
    init() {
        
        print("first view init")
        
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Image(statusController.getStatusStr())
                    .resizable()
                    .scaledToFit()
                    .frame(height: 35.0)
                Text(currentTime.getTimeStr())
                    .font(Font.custom("Roboto-Light", size: 64.0))
                GeometryReader { geometry in
                    VStack() {
                        
                        Button(action: {
                            statusController.changeState(buttonNum: 0)
                            let beforeStatus = statusController.getBeforeStatusType()
                            switch beforeStatus {
                            case .offDuty:
                                print("off -> working")
                                startTimer()
                                if restAlertFlag {
                                    NotificationController().makeRestNotification(interval: restInterval, labelTime: restInterval)
                                }
                                if supplyAlertFlag {
                                    NotificationController().makeSupplyNotification(interval: supplyInterval, labelTime: supplyInterval)
                                }
                                break
                            default:
                                print("working/rest -> water")
                                if supplyAlertFlag {
                                    NotificationController().makeSupplyNotification(interval: supplyInterval, labelTime: supplyInterval)
                                }
                                break
                            }
                        }){
                            Image(statusController.getbutton0ImageName(isPressed: isPressed[0]))
                                .resizable()
                                .frame(width:geometry.frame(in:.local).width*0.7,height: geometry.frame(in:.local).width*0.7*(90/315))
                        }
                        .pressAction{
                            isPressed[0]=true
                        } onRelease: {
                            isPressed[0]=false
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            statusController.changeState(buttonNum: 1)
                            let beforeStatus = statusController.getBeforeStatusType()
                            switch beforeStatus {
                            case .working:
                                print("working -> rest")
                                if restAlertFlag {
                                    NotificationController().removeRestNotification()
                                }
                                if endOfRestAlertFlag {
                                    NotificationController().makeEndOfRestNotification(interval: restTime, labelTime: restTime)
                                }
                                stopTimer()
                                startTimer()
                                break
                            case .takingBreak:
                                print("rest -> working")
                                if restAlertFlag {
                                    NotificationController().makeRestNotification(interval: restInterval, labelTime: restInterval)
                                }
                                if endOfRestAlertFlag {
                                    NotificationController().removeEndOfRestNotification()
                                }
                                stopTimer()
                                startTimer()
                            default:
                                break
                            }
                        }){
                            Image(statusController.getbutton1ImageName(isPressed: isPressed[1]))
                                .resizable()
                                .frame(width:geometry.frame(in:.local).width*0.7,height: geometry.frame(in:.local).width*0.7*(90/315))
                        }
                        
                        .pressAction{
                            isPressed[1]=true
                        } onRelease: {
                            isPressed[1]=false
                        }
                        .isInvisible(statusController.getbutton1Flag())
                        
                        Spacer()
                        
                        Button(action: {
                            statusController.changeState(buttonNum: 2)
                            let beforeStatus = statusController.getBeforeStatusType()
                            switch beforeStatus {
                            case .working:
                                print("working -> off")
                                if restAlertFlag {
                                    NotificationController().removeRestNotification()
                                }
                                if supplyAlertFlag {
                                    NotificationController().removeSupplyNotification()
                                }
                                stopTimer()
                                break
                            default:
                                break
                            }
                        }){
                            Image(statusController.getbutton2ImageName(isPressed: isPressed[2]))
                                .resizable()
                                .frame(width:geometry.frame(in:.local).width*0.7,height: geometry.frame(in:.local).width*0.7*(90/315))
                        }
                        .pressAction{
                            isPressed[2]=true
                        } onRelease: {
                            isPressed[2]=false
                        }
                        .isInvisible(statusController.getbutton2Flag())
                    }
                    .frame(width: geometry.frame(in:.local).width, height: geometry.frame(in:.local).width*0.75)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        stopTimer()
                        self.isSettigViewActive.toggle()
                    }){
                        Image("settingIcon")
                    }.sheet(isPresented: $isSettigViewActive, onDismiss: didDismiss) {
                        SettingView(
                            restAlertFlag: $restAlertFlag,
                            supplyAlertFlag: $supplyAlertFlag,
                            endOfRestAlertFlag: $endOfRestAlertFlag,
                            restInterval: $restInterval,
                            restTime: $restTime,
                            supplyInterval: $supplyInterval,
                            statusController: $statusController,
                            accumulatedTime: currentTime
                        )
                    }
                }
            }
        }
    }
    
    func didDismiss() {
        let status = statusController.getStatusType()
        print("didDismiss: \(status)")
        switch status {
        case .working:
            reStartTimer()
            break
        case .takingBreak:
            reStartTimer()
            break
        case .offDuty:
            return
        }
        
    }
    
    func reStartTimer() {
        if timerStopDate == "" {
            print("timerStopDate is empty")
            return
        }
        
        if timerStartDate == "" {
            print("timerStartDate is empty")
            return
        }
        
        if let unwrapedTimerHandler = timerHandler {
            if unwrapedTimerHandler.isValid {
                print("timer is invalidate")
                return
            }
        }
        
        let stop = DateController().dateFromString(string: timerStopDate, format: "yyyy/MM/dd HH:mm:ss")
        let cal = Calendar(identifier: .gregorian)
        let diff = cal.dateComponents([.second], from: stop, to: Date())
        var startDate = DateController().dateFromString(string: timerStartDate, format: "yyyy/MM/dd HH:mm:ss")
        startDate = cal.date(
            byAdding: .hour,
            value: ((diff.second ?? 0)/3600),
            to: startDate)!
        startDate = cal.date(
            byAdding: .minute,
            value: ((diff.second ?? 0)/60%60),
            to: startDate)!
        startDate = cal.date(
            byAdding: .second,
            value: ((diff.second ?? 0)%60),
            to: startDate)!
        timerStartDate = DateController().stringFromDate(date: startDate, format: "yyyy/MM/dd HH:mm:ss")
        currentTime.resetTime()
        countTime()
        
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            countTime()
        }
    }
    
    
    /**
     タイマー開始関数
     
     ステータスが.takingBreak->.workingの時は以前の続きからカウントを再開
     */
    func startTimer() {
        if let unwrapedTimerHandler = timerHandler {
            if unwrapedTimerHandler.isValid {
                return
            }
        }
        
        let status = statusController.getStatusType()
        switch status {
        case .working:
            print("workTime: \(workTime)")
            let beforeStatus = statusController.getBeforeStatusType()
            
            if (beforeStatus != .takingBreak) {
                print("off -> working")
                workTime.resetTime()
                currentTime.resetTime()
                timerStartDate = DateController().stringFromDate(date: Date(), format: "yyyy/MM/dd HH:mm:ss")
            } else {
                print("rest -> working")
                let cal = Calendar(identifier: .gregorian)
                var dateTmp = Date()
                dateTmp = cal.date(
                    byAdding: .hour,
                    value: -workTime.getH(),
                    to: dateTmp)!
                dateTmp = cal.date(
                    byAdding: .minute,
                    value: -workTime.getM(),
                    to: dateTmp)!
                dateTmp = cal.date(
                    byAdding: .second,
                    value: -workTime.getS(),
                    to: dateTmp)!
                timerStartDate = DateController().stringFromDate(date: dateTmp, format: "yyyy/MM/dd HH:mm:ss")
                currentTime.resetTime()
                countTime()
            }
            break
        case .takingBreak:
            workTime = currentTime
            currentTime.resetTime()
            workTimerStartDate = timerStartDate
            timerStartDate = DateController().stringFromDate(date: Date(), format: "yyyy/MM/dd HH:mm:ss")
            print(".takingBreak")
            break
        default:
            break
        }
        
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            //            currentTime.countUpTime()
            countTime()
        }
    }
    
    
    /**
     タイマー停止関数
     */
    private func stopTimer() {
        timerStopDate = DateController().stringFromDate(date: Date(), format: "yyyy/MM/dd HH:mm:ss")
        timerHandler?.invalidate()
        let state = statusController.getStatusType()
        if state == .offDuty {
            currentTime.resetTime()
        }
    }
    
    /**
     タイマーで呼び出して時間をカウントする関数
     
     バックグラウンド時の時間も計測するため、Date型の差分を取る
     */
    private func countTime(){
        let start = DateController().dateFromString(string: timerStartDate, format: "yyyy/MM/dd HH:mm:ss")
        let now = Date()
        let cal = Calendar(identifier: .gregorian)
        let diff = cal.dateComponents([.second], from: start, to: now)
        
        currentTime.setTime(
            h: ((diff.second ?? 0)/3600),
            m: ((diff.second ?? 0)/60%60),
            s: ((diff.second ?? 0)%60)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
