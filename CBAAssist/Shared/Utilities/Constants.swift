//
//  Constatns.swift
//  CBAAssist
//
//  Created by Cole M on 3/21/22.
//

import Foundation

struct Constants {
    static let SHORTCODE_REQUEST_TIMEOUT = 4.0
    static let TOKEN_ENDPOINT = "/assistserver/shortcode/consumer?appkey="
    static let CREATE_SHORTCODE_ENDPOINT = "/assistserver/shortcode/create"
    static let TOKEN_CREATE_FORBIDDEN = 403
    static let SDK_VERSION = "2.0.0"
}
