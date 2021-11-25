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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
