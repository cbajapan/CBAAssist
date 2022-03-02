//
//  CBAAssistApp.swift
//  CBAAssist
//
//  Created by Cole M on 3/2/22.
//

import SwiftUI

@main
struct CBAAssistApp: App {
    
    @State var exists: Bool = false
    @StateObject var supportSessionManager = SupportSessionManager()
    
    var body: some Scene {
        WindowGroup {
            if exists {
                //Use AsyncView to Handle any needed setup before presenting ContentView
            AsyncView {
                
            } build: {
                ContentView()
                    .environmentObject(supportSessionManager)
            }
            } else {
                ContentView()
                    .environmentObject(supportSessionManager)
            }
        }
    }
}
