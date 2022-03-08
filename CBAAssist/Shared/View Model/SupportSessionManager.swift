//
//  SupportSessionViewModel.swift
//  CBAAssist
//
//  Created by Cole M on 3/2/22.
//

import Foundation
import LASDK
import UIKit
import SwiftUI

class SupportSessionManager: ObservableObject {
    
    
    
    var config: LASDK.Configuration?
    var lasdk: LASDK?

    @AppStorage("server") var server: String = "https://cx-la-latest-qa.cbaqa.com"
    @AppStorage("destination") var destination: String = "Cole"
    @AppStorage("correlationId") var correlationId: String = ""
    @AppStorage("uui") var uui: String = ""
    
    
    init() {
        //Load Configuration
        self.config = LASDK.Configuration(
            server: server,
            destination: destination,
            maskColor: .darkGray,
            correlationId: correlationId,
            uui: uui)
//        config?.server = server
//        config?.destination = destination
//        config?.correlationId = correlationId
//        config?.maskColor = UIColor.darkGray
//        config?.maskingTags = [""]
//        config?.uui = uui
//        print(config?.server, "SERVER__")
    }
    
    
    
    
    func startSupportSession() async {
        //Make call to start support session
        do {
            self.lasdk = try await LASDK.startSupport(self.config!)
        } catch {
            print(error)
        }
    }
    
    func startShare() async {
//        self.lasdk.startShare
    }
    
    func endShare() async {
        await self.lasdk?.endSupport()
    }
}
