//
//  Animation.swift
//  BusAlert
//
//  Created by Chia cheng Lin on 2018/2/9.
//  Copyright © 2018年 Chia cheng Lin. All rights reserved.
//

import Foundation
import UIKit

struct Animation {
    static func labelAnimation(label: UILabel, view: UIView) {
        label.center.x = view.center.x
        label.center.x -= view.bounds.width
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
            label.center.x += view.bounds.width
            view.layoutIfNeeded()
        }, completion: nil)
    }
}
