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
import Logging

class SupportSessionManager: NSObject, ObservableObject, ScreenShareRequestedDelegate {
    func assistSDKScreenShareRequested(_ allow: @Sendable @escaping () -> Void, deny: @Sendable @escaping () -> Void) async {
        Logger(label: "Screenshare Delegate").info("Request for screen share called.")
        allow()
    }
    
    var config: Configuration?
    //    var lasdk: LASDK?
    var assistSDK: AssistSDK?
    var connectionView: ConnectionView?
    @Published var connectionViewManager: ConnectionViewManager?
    @Published var presentShortCode: Bool = false
    @Published var shortCode: String = ""
    
    struct SetDefault: Codable {
        var set: Set<Int>?
        @CodableColor var color: UIColor = .darkGray
    }
    
    //We just load arbitrarily right now, but with the setDefault method we can load into AppStorage dynamically when needed
    var tags = SetDefault(set: [503, 504, 500, 505, 501, 506, 502])
    var color = SetDefault(color: UIColor.darkGray)
    
    @AppStorage("server") var server: String = "https://cx-la-latest.cbaqa.com"
    @AppStorage("destination") var destination: String = "Cole".lowercased()
    @AppStorage("correlationId") var correlationId: String = ""
    @AppStorage("uui") var uui: String?
    @AppStorage("acceptSelfSignedCerts") var acceptSelfSignedCerts = true
    @AppStorage("username") var username = "username"
    @AppStorage("maskingTags") var maskingTags: Data?
    @AppStorage("maskColor") var maskColor: Data?
    @AppStorage("auditName") var auditName = "Consumer (iOS)"
    
    
    func hexadecimalCode(for string: String) -> String {
        let data = Data(string.utf8)
        return data.map{ String(format:"%02x", $0) }.joined()
    }
    
    
    func setDefault(_ default: SetDefault?, _ data: Data?) throws -> (SetDefault?, Data?) {
        if `default` != nil {
            guard let `default` = `default` else {
                return (nil, nil)
            }
            
            let setTag = SetDefault(set: `default`.set, color: `default`.color)
            return try (nil, JSONEncoder().encode(setTag))
        }
        
        if data != nil {
            guard let data = data else {
                return (nil, nil)
            }
            let item = try JSONDecoder().decode(SetDefault.self, from: data)
            return (item, nil)
        }
        
        return (nil,nil)
    }
    
    
    func setUpDefaults() {
        uui = hexadecimalCode(for: correlationId)
        
        do {
            let result = try setDefault(tags, nil)
            maskingTags = result.1
            
            let color = try setDefault(color, nil)
            maskColor = color.1
        } catch {
            print(error)
        }
    }
    
    override init() {
        super.init()
        supportTheSession()
    }
    
    func supportTheSession() {
        do {
            self.setUpDefaults()
            //Unwrapping and decoding AppStorage
            guard let tags = try setDefault(nil, maskingTags).0?.set else { return }
            guard let color = try setDefault(nil, maskColor).0?.color else { return }
            guard let uui = uui else { return }
            self.config = Configuration(
                server: server,
                destination: destination,
                maskingTags: tags,
                maskColor: color,
                correlationId: correlationId,
                uui: uui,
                acceptSelfSignedCerts: acceptSelfSignedCerts,
                auditName: auditName
            )
        } catch {
            print(error)
        }
    }
    
    
    
    @MainActor
    func startSupportSession() async {
        //Make call to start support session
        do {
            connectionView?.reset()
            guard let config = config else {
                return
            }
            //TODO: Need to set for short code
            //            config.screenShareRequestedDelegate = self
            Logger(label: "Session Manager").info("Starting with server \(server) with parameters \(config.description)")
            //TODO: -  Add the delegate here to assign it to any subsequent support sessions.
            self.assistSDK = try await AssistSDK.startSupport(self.config!)
        } catch {
            print(error)
        }
    }
    
    func requestShortCode() async {
        do {
            guard let config = config else { return }
            guard let uui = uui else { return }
            let result = try await ShortCode.createShortCode(config: config)
            self.config = Configuration(
                server: server,
                destination: "",
                maskColor: .darkGray,
                correlationId: result.cid ?? "",
                uui: uui,
                sessionToken: result.sessionToken ?? "",
                acceptSelfSignedCerts: true,
                auditName: "Consumer (iOS)",
                connectionDelegate: connectionViewManager,
                retryIntervals: [2.0, 5.0, 10.0, 15.0],
                initialConnectionTimeout: 2,
                maxReconnectTimeouts: [1.0],
                screenShareRequestedDelegate: self
            )
            await startSupportSession()
            await presentShortCodeResult(result.shortCode ?? "")
        } catch {
            print(error)
        }
    }
    @MainActor
    func presentShortCodeResult(_ shortCode: String) async {
        self.shortCode = !shortCode.isEmpty ? "\(shortCode)" : "An error occurred obtaining the Code!"
        presentShortCode = true
    }
    
    func copyCode() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = self.shortCode
    }
    
    func dismissShortCode() async {
        self.presentShortCode = false
        await connectionView?.reset()
        await self.assistSDK?.endSupport()
    }
    
    func endShare() async {
        await self.assistSDK?.endSupport()
    }
}


@propertyWrapper
struct CodableColor {
    var wrappedValue: UIColor
}

extension CodableColor: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Data.self)
        guard let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid color"
            )
        }
        wrappedValue = color
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let data = try NSKeyedArchiver.archivedData(withRootObject: wrappedValue, requiringSecureCoding: true)
        try container.encode(data)
    }
}
