//
//  SupportSessionViewModel.swift
//  CBAAssist
//
//  Created by Cole M on 3/2/22.
//

import LASDKiOS
import UIKit
import SwiftUI
import OSLog

final class SupportSessionManager: NSObject, ObservableObject, AgentCobrowseDelegate, ScreenShareRequestedDelegate, AssistSDKDelegate, AssistErrorReporter, ConsumerDocumentDelegate, AnnotationDelegate, @unchecked Sendable, DocumentViewConstraints {
    
    func onConsumerDocError(_ document: LASDKiOS.SharedDocument?, reason reasonStr: String?) {
        print(reasonStr ?? "")
    }
    
    func onConsumerDocClosed(_ document: LASDKiOS.SharedDocument?, by whom: LASDKiOS.DocumentCloseInitiator) {
        print(whom.rawValue)
    }
    
    var topMargin: CGFloat = 50
    var bottomMargin: CGFloat = 50
    var leftMargin: CGFloat = 15
    var rightMargin: CGFloat = 15
    
    weak var constraintsDelegate: DocumentViewConstraints?
    
    func assistSDKWillAddAnnotation(_ notification: Notification?) {
        
    }
    
    func assistSDKDidAddAnnotation(_ notification: Notification?) {
        
    }
    
    func assistSDKDidClearAnnotations(_ notification: Notification?) {
        
    }
    
    
    var config: Configuration?
    var assistSDK: AssistSDK?
    var connectionView: ConnectionView?
    @Published var connectionViewManager: ConnectionViewManager?
    @Published var presentShortCode: Bool = false
    @Published var shortCode: String = ""
    @Published var errorCode: String = ""
    
    struct SetDefault: Codable {
        var set: [Int]?
        @CodableColor var color: UIColor = .darkGray
    }
    
    //We just load arbitrarily right now, but with the setDefault method we can load into AppStorage dynamically when needed
    var tags = SetDefault(set: [503, 504, 500, 505, 501, 506, 502])
    var color = SetDefault(color: UIColor.darkGray)

    //App Settings
    @AppStorage("SupportURL") var supportServerAddess: String = ""
    @AppStorage("CorrelationID") var correlationId: String = ""
    @AppStorage("AgentToCall") var agentToCall = ""
    @AppStorage("uui") var uui: String?
    @AppStorage("AcceptSelfSignedCerts") var acceptSelfSignedCerts = false
    @AppStorage("AuditName") var auditName = ""
    
    //App Setup
    @AppStorage("maskingTags") var maskingTags: Data?
    @AppStorage("maskColor") var maskColor: Data?
    
    func hexadecimalCode(for string: String) -> String {
        let string = string.lowercased()
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
    
    @MainActor
    func setUpDefaults() {
        uui = hexadecimalCode(for: agentToCall.lowercased())
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
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.supportTheSession()
            self.constraintsDelegate?.topMargin = 100
        }
    }
    
    deinit {
        print("Reclaiming memory from Support Session Manager")
    }
    
    func addDelegate() {
        Task { @MainActor [weak self] in
            guard let self else { return }
                AssistSDK.addDelegate(self)
            }
        }
    
    //TODO: Create a toggle so that we can test video mode options in the QA Process
    @MainActor
    func supportTheSession() {
        do {
            self.setUpDefaults()
            //Unwrapping and decoding AppStorage
            guard let tags = try setDefault(nil, maskingTags).0?.set else { return }
            guard let color = try setDefault(nil, maskColor).0?.color else { return }
            guard let uui = uui else { return }
            self.config = Configuration(
                server: supportServerAddess.lowercased(),
                autoStart: false,
                destination: agentToCall.lowercased(),
                maskingTags: tags,
                maskColor: color,
                correlationId: correlationId.lowercased(),
                uui: uui.lowercased(),
                videoMode: .full,
                acceptSelfSignedCerts: true,
                keepAnnotationsOnChange: true,
                auditName: auditName.lowercased(),
                agentCobrowseDelegate: self,
                screenShareRequestedDelegate: self,
                documentViewConstraints: self,
                isProgrammaticUI: true
            )
            
        } catch {
            print(error)
        }
    }
    
  
    @MainActor
    func startSupportSession(_ config: Configuration? = nil) async {
        //Make call to start support session
        do {
            supportTheSession()
            var config = config
            
            //we set a new config for Short Code 
            if config == nil {
                config = self.config
            }
            guard let config = config else { return }
            connectionView?.reset()
            Logger(subsystem: "Session Manager", category: "Start").info("Starting with server \(self.supportServerAddess) with parameters \(config.description)")
            addDelegate()
            await assistSDK?.resetAllWebPermissions()
            self.assistSDK = try await AssistSDK.startSupport(config)
            
        } catch {
            print(error)
        }
    }
    
    func requestShortCode() async {
        do {
            if self.config == nil { supportTheSession() }
            guard let config = self.config else { return }
            guard let uui = uui else { return }
            let result = try await ShortCode.createShortCode(config: config)

            //Change Config on
            self.config = Configuration(
                server: supportServerAddess.lowercased(),
                maskColor: .darkGray,
                correlationId: result.cid?.lowercased() ?? "",
                uui: uui.lowercased(),
                sessionToken: result.sessionToken ?? "",
                acceptSelfSignedCerts: true,
                keepAnnotationsOnChange: true,
                auditName: auditName.lowercased(),
                connectionDelegate: connectionViewManager,
                retryIntervals: [2.0, 5.0, 10.0, 15.0],
                initialConnectionTimeout: 2,
                maxReconnectTimeouts: [1.0],
                screenShareRequestedDelegate: self,
                documentViewConstraints: self,
                isProgrammaticUI: true
            )
            guard let config = self.config else { return }
            await presentShortCodeResult(result.shortCode ?? "")
            await startSupportSession(config)
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
        connectionView?.reset()
        self.assistSDK?.endSupport()
    }
}


extension SupportSessionManager {
    func assistSDKDidEncounterError(_ error: LASDKErrors) {
        Task { @MainActor in
            self.errorCode = "\(error)"
        }
        print("\(#function)", error)
        switch error {
        case .fcsdkSessionFailure:
            break
        case .fcsdkSystemFailure:
            break
        case .fcsdkLostConnection:
            break
        case .fcsdkDidReceiveCallFailure:
            break
        case .fcsdkDidReceiveDialFailure:
            break
        case .calleeNotFound:
            break
        case .assistSessionCreationFailure:
            break
        case .assistConsumerDocumentShareFailedNotScreenSharing:
            break
        case .assistSupportEnded:
            break
        case .calleeBusy:
            break
        case .callCreationFailed:
            break
        case .callTimeout:
            break
        case .callFailed:
            break
        case .sessionFailure:
            break
        case .cameraNotAuthorized:
            break
        case .microphoneNotAuthorized:
            break
        case .assistTransportFailure:
            break
        case .assistSessionInProgress:
            break
        case .unknownMimeType:
            break
        default:
            break
        }
    }
    
    
    func cobrowseActiveDidChange(to active: Bool) {
        print("\(#function)", active)
    }
    
    func supportCallDidEnd() {
        print("\(#function)")
        assistSDK = nil
        config = nil
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.connectionViewManager = nil
            self.connectionView = nil
            self.maskingTags = nil
            self.maskColor = nil
        }
    }
    
    func onError(_ document: SharedDocument?, reason reasonStr: String?) {
        
    }
    
    func onClosed(_ document: SharedDocument?, by whom: DocumentCloseInitiator) {
        
    }
    
    func agentJoinedSession(_ agent: Agent) async {
        print("AGENT_JOINED___SESSION")

    }
    
    func agentLeftSession(_ agent: Agent) async {
        print("AGENT_LEFT___SESSION")
    }
    
    func agentRequestedCobrowse(_ agent: Agent) async {
        await AssistSDK.shared.allowCobrowse(for: agent)
    }
    
    func agentJoinedCobrowse(_ agent: Agent) async {
       let viewablePermissions = agent.permissions?.viewable
        print("Agent_Joined_Cobrowse_With____", viewablePermissions ?? "")
    }
    
    func agentLeftCobrowse(_ agent: LASDKiOS.Agent) async {
        print("AGENT_LEFT___Cobrowse")
    }
    
    func assistSDKScreenShareRequested(_ allow: @escaping @MainActor @Sendable () -> Void, deny: @escaping @MainActor @Sendable () -> Void) async {
        Logger(subsystem: "Session Manager", category: "Screenshare Delegate").info("Request for screen share called.")
        allow()
    }
    
    func consumerShareURL(_ url: URL) async {
        do {
        try await shareDoc(url)
    } catch {
        print(error)
    }
    }
    
    private func shareDoc(_ url: URL) async throws {
        print("SHARE_URL", url)
            try await self.assistSDK?.shareDocumentUrl(url, delegate: self)
    }
     
    func consumerShareContent(_ contentSelected: String) async throws {
        let `extension` = URL(fileURLWithPath: contentSelected).pathExtension
        let resourceName = URL(fileURLWithPath: "Resource_\(contentSelected)").deletingPathExtension().path
        guard let resourceUrl = Bundle.main.url(forResource: resourceName, withExtension: `extension`) else { return }
        try await shareDoc(resourceUrl)
     
//        logShareError(shareError)
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

extension SupportSessionManager: ACBUCDelegate, ACBClientCallDelegate {
    
    
    func fcsdkStart() async {
        let uc = await ACBUC.uc(withConfiguration: "", delegate: self)
        await uc.startSession()
    }

    func didStartSession(_ uc: ACBUC) async {}
    
    func didChange(_ status: ACBClientCallStatus, call: ACBClientCall) async {
        if status == .inCall {
        // Escalate call to co-bowse
        }
    }
    
}



extension UIApplication {
    
    @MainActor
    public var firstWindowScence: UIWindowScene? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })
    }
    
    @MainActor
    public var orientation: UIInterfaceOrientation? {
        return UIApplication.shared.firstWindowScence?.interfaceOrientation
    }
}
