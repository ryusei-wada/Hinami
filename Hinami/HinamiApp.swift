//
//  HinamiApp.swift
//  Hinami
//
//  Created by Ryusei Wada on 2021/11/25.
//

import SwiftUI

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
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("フリックしてアプリを終了させた時に呼ばれる")
    }
}
