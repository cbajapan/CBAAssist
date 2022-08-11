//
//  ConnectionView.swift
//  CBAAssist
//
//  Created by Cole M on 3/22/22.
//

import SwiftUI
import LASDK


struct ConnectionView: View {
    
    @EnvironmentObject var connectionViewManager: ConnectionViewManager
    
    
    var body: some View {
        VStack {
            HStack {
                Button(self.connectionViewManager.statusText) {
                    print("Status Text")
                }
                Button(self.connectionViewManager.reconnectionInfo) {
                    print("Reconnection Info")
                }
            }
        }
    }
    
    func reset() {
        self.connectionViewManager.reset()
    }
}

//struct ConnectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConnectionView()
//    }
//}
