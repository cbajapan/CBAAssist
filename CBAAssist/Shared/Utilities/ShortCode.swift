//
//  ShortCode.swift
//  CBAAssist
//
//  Created by Cole M on 3/21/22.
//

import Foundation
import LASDK

class ShortCode: NSObject, URLSessionDelegate, URLSessionTaskDelegate {
    
    
    struct Code: Codable {
        var shortCode: String
    }
    
    @available(iOS 15.0, *)
    class func createShortCode(_ serverUrl: String, lasdk: LASDK, config: LASDK.Configuration) async throws -> TokenResult {
        guard let serverInfo = try await lasdk.parseURL(serverUrl) else { throw OurErrors.nilURL }
        let host = serverInfo.host
        let scheme = serverInfo.scheme
        let port = serverInfo.port
        let url = "\(scheme)://\(host):\(port)"
        
        var path = Constants.CREATE_SHORTCODE_ENDPOINT
        
        if !config.auditName.isEmpty {
            path = "?auditName=\(config.auditName)"
        }
        
        let result = try await URLSession.shared.codableNetworkWrapper(
            type: Code.self,
            httpHost: url,
            urlPath: path,
            httpMethod: "PUT",
            timeoutInterval: Constants.SHORTCODE_REQUEST_TIMEOUT
        )
        
        let decodedData = try JSONDecoder().decode(Code.self, from: result.data)
        let shortCode = decodedData.shortCode
        
        
        var tokenPath = "\(Constants.TOKEN_ENDPOINT)\(shortCode)"
        if !config.auditName.isEmpty {
            tokenPath = "&auditName=\(config.auditName)"
        }
        
        let tokenResult = try await URLSession.shared.codableNetworkWrapper(
            type: TokenResult.self,
            httpHost: url,
            urlPath: tokenPath,
            httpMethod: "GET",
            timeoutInterval: Constants.SHORTCODE_REQUEST_TIMEOUT
        )
        
        return try JSONDecoder().decode(TokenResult.self, from: tokenResult.data)
    }
    
    struct TokenResult: Codable {
        var cid: String
        var sessionToken: String
    }
    
    
    func urlSession(
        _
        session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?
        ) -> Void) {
        
        if challenge.protectionSpace.serverTrust == nil {
            completionHandler(.useCredential, nil)
        } else {
            let trust: SecTrust = challenge.protectionSpace.serverTrust!
            let credential = URLCredential(trust: trust)
            completionHandler(.useCredential, credential)
        }
    }
}

