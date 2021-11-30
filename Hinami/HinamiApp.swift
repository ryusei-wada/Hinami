//
//  HinamiApp.swift
//  Hinami
//
//  Created by Ryusei Wada on 2021/11/25.
//

import SwiftUI
import UserNotifications

@main
struct HinamiApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate  // 追加する
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("didFinishLaunch")
        
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]){
            (granted, _) in
            if granted {
                print("通知許可済み")
            }else {
                print("通知拒否状態")
            }
        }
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        NotificationController().removeRestNotification()
        NotificationController().removeEndOfRestNotification()
        NotificationController().removeSupplyNotification()
        print("フリックしてアプリを終了させた時に呼ばれる")
    }
    
    static var orientationLock = UIInterfaceOrientationMask.portrait //By default you want all your views to rotate freely
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // フォアグラウンドで通知を受け取るために必要
    // フォアグラウンドで通知を受信した時
    // UNUserNotificationCenter.current().delegate = self も必須
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
