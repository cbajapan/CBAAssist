//
//  AppSettigns.swift
//  CBAAssist
//
//  Created by Cole M on 11/9/22.
//

import Foundation
import LASDKiOS

final class AppSettings: ObservableObject {
    
    @Published var version = UserDefaults.standard.string(forKey: "SDKVersion") ?? "\(Constants.SDK_VERSION)"
    @Published var website = UserDefaults.standard.string(forKey: "Website") ?? ""
    @Published var supportServerAddess = UserDefaults.standard.string(forKey: "SupportURL") ?? ""
    @Published var iconImage = UserDefaults.standard.string(forKey: "IconImage") ?? ""
    @Published var agent = UserDefaults.standard.string(forKey: "Agent") ?? ""
    @Published var username = UserDefaults.standard.string(forKey: "Username") ?? ""
    @Published var correlationId = UserDefaults.standard.string(forKey: "CorrelationID") ?? ""
    @Published var userToUserInfo = UserDefaults.standard.string(forKey: "UserInfo") ?? ""
    @Published var auditName = UserDefaults.standard.string(forKey: "AuditName") ?? ""
    @Published var autoStart = UserDefaults.standard.bool(forKey: "AutoStart")
    @Published var acceptSelfSignedCerts = UserDefaults.standard.bool(forKey: "AcceptSelfSignedCerts")
    @Published var secureText = ""
    
    
}
