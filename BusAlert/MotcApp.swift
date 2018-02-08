//
//  MOTCAppKey.swift
//  BusAlert
//
//  Created by Chia cheng Lin on 2018/2/8.
//  Copyright © 2018年 Chia cheng Lin. All rights reserved.
//

import Foundation
import CryptoSwift

struct MotcApp {
    struct Id {
        static let l1 = "dae076a37f6b4d3fa3bc96c7c9de6222"
        static let l2 = "8c805e40fa3e488fb2f887ba642f98c4"
    }
    struct Key {
        static let l1 = "dWKuqWJ9ZF7a2FrWpa-Q98I03tM"
        static let l2 = "jKedmykPMMO1ED7J9uyem1ivY6w"
    }
    
    static func getCurrentDateWithGMT() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy hh:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        let result = formatter.string(from: date)
        
        return result
    }
    
   static func getSignature(dateString: String) -> String {
        
        let finalString = "x-date: " + dateString
        let hmacString = try? HMAC.init(key: MotcApp.Key.l1, variant: .sha1).authenticate(finalString.bytes)
        let base64String = hmacString?.toBase64() ?? ""
        
        return base64String
    }
    
    static func urlRequestAddMotcHeader(url: URL) -> URLRequest {
        var newUrlRequest = URLRequest(url: url)
        let currentDate = MotcApp.getCurrentDateWithGMT()
        let signature = MotcApp.getSignature(dateString: currentDate)
        
        newUrlRequest.addValue("hmac username=\"\(MotcApp.Id.l1)\", algorithm=\"hmac-sha1\", headers=\"x-date\", signature=\"\(signature)\"", forHTTPHeaderField: "Authorization")
        
        
        newUrlRequest.addValue(currentDate, forHTTPHeaderField: "x-date")
        
        return newUrlRequest
    }
    
}
