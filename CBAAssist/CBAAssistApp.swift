//
//  CBAAssistApp.swift
//  CBAAssist
//
//  Created by Cole M on 3/2/22.
//

import SwiftUI

@main
struct CBAAssistApp: App {
    
    @StateObject var supportSessionManager = SupportSessionManager()
    @StateObject var connectionViewManager = ConnectionViewManager()
    @StateObject var appSettings = AppSettings()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appSettings)
                .environmentObject(supportSessionManager)
                .environmentObject(connectionViewManager)
                .onChange(of: scenePhase) { phase in
                    switch phase {
                    case .active:
                        print("active")
                    case .inactive:
                        print("inactive")
                    case .background:
                        print("background")
                    default:
                        print("default")
                    }
                }
        }
    }
}
