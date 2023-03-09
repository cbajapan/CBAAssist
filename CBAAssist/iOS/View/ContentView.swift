//
//  ContentView.swift
//  CBAAssist
//
//  Created by Cole M on 3/2/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var supportSessionManager: SupportSessionManager
    @State var showErrorAlert: Bool = false
    
    var body: some View {
        
        if #available(iOS 15.0, *) {
            TabView {
                ZStack {
                    AssistWebView()
                }
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Web")
                }
                ZStack {
                    NativeView()
                }
                .tabItem {
                    Image(systemName: "swift")
                    Text("Native")
                }
                ZStack {
                    AppSettingsView()
                }
                .tabItem {
                    Image(systemName: "gear")
                    Text("App Settings")
                }
                
            }
            .onReceive(supportSessionManager.$errorCode, perform: { output in
                if output != "" {
                    showErrorAlert = true
                }
            })
            .alert("Error: - \(supportSessionManager.errorCode)", isPresented: $showErrorAlert) {
                    Button("Dismiss") {
                        self.showErrorAlert = false
                        supportSessionManager.errorCode = ""
                    }
                }
        } else {
            TabView {
                ZStack {
                    AssistWebView()
                }
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Web")
                }
                ZStack {
                    NativeView()
                }
                .tabItem {
                    Image(systemName: "swift")
                    Text("Native")
                }
                ZStack {
                    AppSettingsView()
                }
                .tabItem {
                    Image(systemName: "gear")
                    Text("App Settings")
                }
                
            }
            .onReceive(supportSessionManager.$errorCode, perform: { output in
                if output != "" {
                    showErrorAlert = true
                }
            })
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("There was an error"),
                      message:  Text("\(supportSessionManager.errorCode)"),
                      dismissButton: .default(Text("Dismiss"), action: {
                    self.showErrorAlert = false
                    supportSessionManager.errorCode = ""
                }))
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
