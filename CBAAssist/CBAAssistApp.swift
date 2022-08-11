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
    
    var body: some Scene {
        WindowGroup {
                ContentView()
                    .environmentObject(supportSessionManager)
                    .environmentObject(connectionViewManager)
            }
        }
    }
