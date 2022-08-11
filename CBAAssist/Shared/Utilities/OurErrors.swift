//
//  OurErrors.swift
//  CBAAssist
//
//  Created by Cole M on 3/21/22.
//

import Foundation
enum OurErrors: String, Swift.Error {
    case nilURL = "The URL is nil for network calls"
    case nilShortCode = "There was a problem generating short code"
}
