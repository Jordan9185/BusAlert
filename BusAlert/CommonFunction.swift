//
//  CommonFunction.swift
//  BusAlert
//
//  Created by Chia cheng Lin on 2018/2/9.
//  Copyright © 2018年 Chia cheng Lin. All rights reserved.
//

import Foundation
import UIKit

struct CommonFunction {
    static func phoneCall(who number:String) {
        
        if let url = URL(string: "telprompt://\(number)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            print("phone number is not correct format")
        }
    }
}
