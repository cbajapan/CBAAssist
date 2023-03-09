//
//  ShortCode.swift
//  CBAAssist
//
//  Created by Cole M on 3/21/22.
//

import Foundation
import LASDKiOS

class ShortCode: NSObject, URLSessionDelegate, URLSessionTaskDelegate {
    
    class func createShortCode(config: Configuration) async throws -> ShortCode {
        let serverInfo = try await AssistSDK.parseURL(config)
        let host = serverInfo.host
        let scheme = serverInfo.scheme
        let port = serverInfo.port
        let url = "\(scheme)://\(host):\(port)"
        let auditName = config.auditName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        var path = Constants.CREATE_SHORTCODE_ENDPOINT

        if !config.auditName.isEmpty {
            path += "?auditName=\(auditName)"
        }

        let result = try await URLSession.shared.codableNetworkWrapper(
            type: ShortCode.self,
            httpHost: url,
            urlPath: path,
            httpMethod: "PUT",
            timeoutInterval: Constants.SHORTCODE_REQUEST_TIMEOUT
        )

        let decodedData = try JSONDecoder().decode(ShortCode.self, from: result.data)
        guard let shortCode = decodedData.shortCode else { throw OurErrors.nilShortCode }
        
        var tokenPath = "\(Constants.TOKEN_ENDPOINT)\(shortCode)"
        if !config.auditName.isEmpty {
            tokenPath += "&auditName=\(auditName)"
        }
        
        let tokenResult = try await URLSession.shared.codableNetworkWrapper(
            type: ShortCode.self,
            httpHost: url,
            urlPath: tokenPath,
            httpMethod: "GET",
            timeoutInterval: Constants.SHORTCODE_REQUEST_TIMEOUT
        )

        var tr = try JSONDecoder().decode(ShortCode.self, from: tokenResult.data)
        tr.shortCode = shortCode
        return tr
    }
    
    struct ShortCode: Codable {
        var cid: String?
        var sessionToken: String?
        var shortCode: String?
        
        enum CodingKeys: String, CodingKey {
            case cid
            case sessionToken = "session-token"
            case shortCode
        }
        
        internal init(
            cid: String?,
            sessionToken: String?,
            shortCode: String?
        ) {
            self.cid = cid
            self.sessionToken = sessionToken
            self.shortCode = shortCode
        }
        internal init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.cid = try container.decodeIfPresent(String.self, forKey: .cid)
            self.sessionToken = try container.decodeIfPresent(String.self, forKey: .sessionToken)
            self.shortCode = try container.decodeIfPresent(String.self, forKey: .shortCode)
        }
        
        internal func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(self.cid, forKey: .cid)
            try container.encodeIfPresent(self.sessionToken, forKey: .sessionToken)
            try container.encodeIfPresent(self.shortCode, forKey: .shortCode)
        }
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

