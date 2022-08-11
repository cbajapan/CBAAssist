//
//  ContentView.swift
//  CBAAssist
//
//  Created by Cole M on 3/2/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
                AssistWebView()
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Web")
                }
            
            NativeView()
                .tabItem {
                    Image(systemName: "swift")
                    Text("Native")
                }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
