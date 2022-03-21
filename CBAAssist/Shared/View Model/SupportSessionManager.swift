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

    @AppStorage("server") var server: String = "https://cx-la-latest.cbaqa.com"
    @AppStorage("destination") var destination: String = "Cole".lowercased()
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
    }
    
    
    func startSupportSession() async {
        //Make call to start support session
        do {
            self.lasdk = try await LASDK.startSupport(self.config!)
        } catch {
            print(error)
        }
    }
    
    @available(iOS 15.0, *)
    func requestShortCode() async {
        do {
        let result = try await ShortCode.createShortCode(config!.server, lasdk: lasdk!, config: config!)
            //TODO: - write short code logic in LASDK, RESULT NEEDS TO CONTAIN CID, SESSION TOKEN
//            [self shortCodeParametersWithCorrelationId:shortCode.cid sessionToken:shortCode.sessionToken];
        } catch {
            print(error)
        }
    }
    
//    -(void) requestShortCode {
//         NSString *serverUrl = [SupportParameters serverHost];
//
//         [ShortCode fromServerUrl:serverUrl withSuccess:^(ShortCode *shortCode) {
//
//
//             NSDictionary *shortCodeParameters =
//            [self shortCodeParametersWithCorrelationId:shortCode.cid sessionToken:shortCode.sessionToken];
//
//             dispatch_async(dispatch_get_main_queue(), ^{
//                 [self showEndSupportButton];
//                 [self presentShortCodeResult:shortCode.shortCode];
//                 [self startLiveAssistWithSupportParameters:shortCodeParameters];
//             });
//
//        } failure:^(NSError *error) {
//            [self presentShortCodeResult:nil];
//        }];
//    }
    
    func endShare() async {
        await self.lasdk?.endSupport()
    }
}
