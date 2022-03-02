//
//  AssistWebView.swift
//  CBAAssist
//
//  Created by Cole M on 3/2/22.
//

import SwiftUI

struct AssistWebView: View {
    
    @State var showSupportAlert = false
@EnvironmentObject var supportSessionManager: SupportSessionManager
    
    
    var body: some View {
        ZStack {
            AssistWebViewResprestable(url: URL(string: "https://www.cba-japan.com")!)
            VStack {
                Spacer()
                HStack {
                    Button(action: {
                       print("button pressed")
                        showSupportAlert = true
                     }) {
                         Image(systemName: "questionmark.circle.fill").resizable().frame(width: 40, height: 40, alignment: .bottomLeading).padding()
                     }
                    Spacer()
                }
            }
        }
        .alert("Share my screen with the support agent?", isPresented: $showSupportAlert) {
            Button("Call support then share") {
                //We want to invoke our LASDK Method in the View Model
                supportSessionManager.startSupportSession()
            }
            Button("Already on a call, let's share") {
                //We want to invoke our LASDK Method in the View Model
                supportSessionManager.startShare()
            }
            Button("I dont need help") {
                //Just Dismiss
            }
        }
    }
}

struct AssistWebView_Previews: PreviewProvider {
    static var previews: some View {
        AssistWebView()
    }
}
