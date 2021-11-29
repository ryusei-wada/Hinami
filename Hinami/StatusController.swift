//
//  StatusController.swift
//  Hinami
//
//  Created by Ryusei Wada on 2021/11/27.
//

import Foundation

/**
 ステータスを定義するためのenum
 */
public enum StatusType {
    /**
     業務時間外のステータス
     */
    case offDuty
    /**
     業務中のステータス
     */
    case working
    /**
     休憩中のステータス
     */
    case takingBreak
}

/**
 ステータス情報を管理するための構造体
 */
public struct StatusController {
    private var status: StatusType
    private var beforeStatus: StatusType = .offDuty
    private var statusDict = [StatusType.offDuty: 0, StatusType.working: 1, StatusType.takingBreak: 2]
    
    private var button0ImageName = ""
    private var button1ImageName = ""
    private var button2ImageName = ""
    
    /**
     StatusControllerのイニシャライザ
     
     引数で指定したstatusと、statusに応じてボタンに表示する画像の名前をプロパティにセットする
     */
    init(status: StatusType){
        self.status = status
        setLabels()
    }
    
    /**
     引数で指定したstatusと、statusに応じてボタンに表示する画像の名前をプロパティにセットする
     */
    mutating func setStatus(_ status: StatusType){
        self.status = status
        setLabels()
    }
    
    /**
     上から2番目のボタンの表示要否をreturnする
     */
    func getbutton1Flag() -> Bool {
        return (status != .offDuty) ? false:true
    }
    
    /**
     上から3番目のボタンの表示要否をreturnする
     */
    func getbutton2Flag() -> Bool {
        return (status == .working) ? false:true
    }
    
    /**
     一つ前のステータスをreturnする
     */
    func getBeforeStatusType() -> StatusType {
        return beforeStatus
    }
    
    /**
     StatusType型でステータスをreturn
     */
    func getStatusType() -> StatusType {
        return status
    }
    
    /**
     String型でステータスをreturn
     
     StatusType型の表記と違うため注意
     */
    func getStatusStr() -> String {
        switch status {
        case .offDuty:
            return "OffDuty"
        case .working:
            return "Working"
        case .takingBreak:
            return "TakingBreak"
        }
    }
    
    /**
     1番上のボタンに表示する画像の名前をreturn
     */
    func getbutton0ImageName(isPressed: Bool) -> String {
        return (isPressed ? "Pushed":"") + button0ImageName
    }
    
    /**
     2番目のボタンに表示する画像の名前をreturn
     */
    func getbutton1ImageName(isPressed: Bool) -> String {
        return (isPressed ? "Pushed":"") + button1ImageName
    }
    
    /**
     3番目のボタンに表示する画像の名前をreturn
     */
    func getbutton2ImageName(isPressed: Bool) -> String {
        return (isPressed ? "Pushed":"") + button2ImageName
    }
    
    /**
     押されたボタン番号（引数）に応じてステータスを遷移させる
     */
    mutating func changeState(buttonNum: Int) {
        beforeStatus = self.status
        switch status {
        case .offDuty:
            switch buttonNum {
            case 0:
                status = .working
                setLabels()
                break
            default:
                break
            }
            break
        case .working:
            switch buttonNum {
            case 0:
                //water supply
                break
            case 1:
                status = .takingBreak
                setLabels()
                break
            case 2:
                status = .offDuty
                setLabels()
                break
            default:
                break
            }
            break
        case .takingBreak:
            switch buttonNum {
            case 0:
                //water supply
                break
            case 1:
                status = .working
                setLabels()
                break
            default:
                break
            }
            break
        }
    }
    
    /**
     ステータスに応じて、ボタンに表示する画像名を指定する
     */
    mutating private func setLabels() {
        switch status {
        case .offDuty:
            button0ImageName = "StartWorkingButton"
            button1ImageName = "DummyButton"
            button2ImageName = "DummyButton"
            break
        case .working:
            button0ImageName = "WaterSupplyButton"
            button1ImageName = "TakeBreakButton"
            button2ImageName = "EndOfWorkButton"
            break
        case .takingBreak:
            button0ImageName = "WaterSupplyButton"
            button1ImageName = "StartWorkingButton"
            button2ImageName = "DummyButton"
            break
        }
    }
}
