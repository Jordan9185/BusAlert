//
//  BusStop.swift
//  BusAlert
//
//  Created by Chia cheng Lin on 2018/2/6.
//  Copyright © 2018年 Chia cheng Lin. All rights reserved.
//

import Foundation

//主要欄位說明
//id :站牌代碼
//routeId:所屬路線代碼(主路線ID)
//nameZh:中文名稱
//nameEn:英文名稱
//seqNo:於路線上的順序
//goBack:去返程（0：去程/ 1：返程 / 2：未知
//longitude:經度
//latitude:緯度
//stopLocationId:站位ID

struct BusStop {
    static let qiaodongForBL15: String = "114984"
    static let qiaodongFor951: String = "180691"
    let id: String
    let routeId: String
    let nameZh: String
    let nameEn: String
    let seqNo: String
    let goBack: GoBack
    let longitude: Double
    let latitude: Double
    let stopLocationId: String
}
