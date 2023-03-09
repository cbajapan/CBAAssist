//
//  ConnectionViewManager.swift
//  CBAAssist
//
//  Created by Cole M on 3/22/22.
//

import UIKit
import LASDKiOS

/// This is class is designed to respond to the user interface when there is a network change via the `ConnectionStatusDelegate`.
class ConnectionViewManager: NSObject, ObservableObject, ConnectionStatusDelegate {
    
    @Published var statusText: String = ""
    @Published var reconnectionInfo: String = ""
    @Published var retryNow: Bool = false
    @Published var giveUp: Bool = false
    @Published var dismiss: Bool = false
    
    @Published var dismissError = false
    @Published var connected = false
    @Published var connectCnt = 0
    @Published var myConnector: Connector?
    @Published var reportedError: Error?
    @Published var myAttemptCnt = 0
    @Published var myMaxAttempts = 0
    @Published var myInSeconds: Float = 0.0
    @Published var updateRetry: Timer?
    
    override init() {
//        super.init(frame: CGRect(x: 300, y: 300, width: 400, height: 200))
        dismissError = false
        connected = false
        connectCnt = 0

//        statusText = UILabel(frame: CGRect(x: 50, y: 20, width: 300, height: 40))
//        reconnectionInfo = UILabel(frame: CGRect(x: 50, y: 80, width: 300, height: 40))
//        retryNow = createButton(at: CGRect(x: 10, y: 150, width: 120, height: 50), text: "Retry Now", handler: Selector("doRetryNow:"))
//        giveUp = createButton(at: CGRect(x: 140, y: 150, width: 120, height: 50), text: "Give Up", handler: Selector("doGiveUp:"))
//        dismiss = createButton(at: CGRect(x: 270, y: 150, width: 120, height: 50), text: "Dismiss", handler: Selector("doDismiss:"))
//        self.hidden = true
//        backgroundColor = UIColor.gray
//        addSubview(statusText)
//        addSubview(reconnectionInfo)
//        addSubview(retryNow)
//        addSubview(giveUp)
//        addSubview(dismiss)
    }

//    func createButton(at rect: CGRect, text: String?, handler: Selector) -> UIButton? {
////        let button = UIButton(type: .custom)
////        button.frame = rect
////        button.setTitle(text, for: .normal)
////        button.isUserInteractionEnabled = true
////        button.addTarget(self, action: handler, for: .touchUpInside)
////        return button
//    }
    
    func doDismiss() {
        
//        cancelUpdateTimer()
        
        //        self.hidden = true
        if !connected {
            dismissError = true
        }
    }
    
    func doGiveUp() async {
//        cancelUpdateTimer()
        
        assert(reportedError != nil, "Error Shouldn't be nil")
        await myConnector?.terminate(reportedError!)
    }
    
    func doRetryNow() async {
        
//        cancelUpdateTimer()
        
        await myConnector?.reconnect(2.0)
    }
    
    func onDisconnect(_ connector: Connector, reason: Error) async {
        print("Connection lost!!!")
        
        reportedError = reason
        
//        cancelUpdateTimer()
        
        retryNow = false
        giveUp = false
        
        myConnector = connector
        connected = false
        if !dismissError {
            //            self.hidden = false
            
            statusText = "Connection Lost!"
        }
    }
    
    func onConnect() async throws {
        print("Connection established!!")
        
        connected = true
        retryNow = true
        giveUp = true
        
        if connectCnt > 0 {
            //            self.hidden = false
            statusText = "Connection re-established!"
            reconnectionInfo = ""
        }
        connectCnt += 1
        dismissError = false
    }
    
    func onTerminated(_ reason: Error) async {
        
//        cancelUpdateTimer()
        
//        print("Connection terminated! \(reason)")
        connected = false
        
//        if (reason as NSError?)?.code == ASDKErrorCode.assistSupportEnded.rawValue {
//            //                self.hidden = true
//        } else {
            //                self.hidden = false
            
            statusText = "Given up!"
            reconnectionInfo = ""
            
            retryNow = true
            giveUp = true
//        }
    }
    
    
    func reset() {
//        cancelUpdateTimer()
        
        retryNow = false
        giveUp = false
        dismiss = false
        
        dismissError = false
        connected = false
        connectCnt = 0
        
        //        self.hidden = true
    }
    
//    func cancelUpdateTimer() {
//        if updateRetry != nil {
//            updateRetry?.invalidate()
//            updateRetry = nil
//        }
//    }
    
//    @objc func updateRetryTime() {
//
//        myInSeconds -= 1
//
//        if myInSeconds > 0.0 {
//            reconnectionInfo = String(format: "Re-connecting in %.1f (%i of %i)", myInSeconds, myAttemptCnt, myMaxAttempts)
//        }
//    }
    
    func willRetry(_ inSeconds: Float, attempt: Int, of maxAttempts: Int, connector: Connector) async {
        
        myInSeconds = inSeconds
        myAttemptCnt = attempt
        myMaxAttempts = maxAttempts
        
        print(String(format: "Will attempt to re-connect in %f seconds (%i of %i)", inSeconds, attempt, maxAttempts))
        myConnector = connector
        
        reconnectionInfo = String(format: "Re-connecting in %.1f (%i of %i)", inSeconds, attempt, maxAttempts)
        
        let error = NSError(domain: "UserAction", code: -1)
        await myConnector?.terminate(error)
        
//        cancelUpdateTimer()
        
//        updateRetry = Timer.scheduledTimer(
//            timeInterval: 1.0,
//            target: self,
//            selector: #selector(updateRetryTime),
//            userInfo: nil,
//            repeats: true)
        
    }
}
