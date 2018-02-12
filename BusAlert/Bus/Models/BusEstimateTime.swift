//
//  BusEstimateTime.swift
//  BusAlert
//
//  Created by Chia cheng Lin on 2018/2/6.
//  Copyright © 2018年 Chia cheng Lin. All rights reserved.
//

import Foundation

//RouteID :路線代碼(主路線ID)
//StopID:站牌代碼
//EstimateTime 預估到站剩餘時間（單位：秒） -1：尚未發車 -2：交管不停靠 -3：末班車已過 -4：今日未營運
//GoBack 去返程 （0：去程 1：返程 2：尚未發車 3：末班已駛離去返程)

struct BusEstimateTime {
    let estimateTime: Int
    let goBack: GoBack
    let routeId: String
    let stopId: String
}
