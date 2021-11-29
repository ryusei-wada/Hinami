//
//  NotificationController.swift
//  Hinami
//
//  Created by Ryusei Wada on 2021/11/29.
//

import Foundation
import UserNotifications

struct NotificationController {
    func makeRestNotification(interval: Int) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]){
            (granted, _) in
            if granted {
                //通知が許可されているときの処理
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                
                let content = UNMutableNotificationContent()
                content.title = "Hinami"
                content.subtitle = "作業開始から\(interval)分経過"
                content.body = "そろそろ休憩をとりませんか？"
                content.sound = UNNotificationSound.default
                
                let request = UNNotificationRequest(identifier: "rest", content: content, trigger: trigger)
                print(request)
                
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }else {
                //通知が拒否されているときの処理
            }
        }
    }
    
    func removeRestNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["rest"])
    }
    
    func makeSupplyNotification(interval: Int) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]){
            (granted, _) in
            if granted {
                //通知が許可されているときの処理
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                
                let content = UNMutableNotificationContent()
                content.title = "Hinami"
                content.subtitle = "前回の給水から\(interval)分経過"
                content.body = "水分を摂取しましょう！"
                content.sound = UNNotificationSound.default
                
                let request = UNNotificationRequest(identifier: "supply", content: content, trigger: trigger)
                print(request)
                
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }else {
                //通知が拒否されているときの処理
            }
        }
    }
    
    func removeSupplyNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["supply"])
    }
}
