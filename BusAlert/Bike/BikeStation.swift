//
//  BikeStation.swift
//  BusAlert
//
//  Created by Chia cheng Lin on 2018/2/14.
//  Copyright © 2018年 Chia cheng Lin. All rights reserved.
//

import Foundation

//BikeAvailability {
//    StationUID (string, optional): 站點唯一識別代碼，規則為 {業管機關代碼} + {StationID}，其中 {業管機關代碼} 可於Authority API中的AuthorityCode欄位查詢 ,
//    StationID (string, optional): 站點代碼 ,
//    ServieAvailable (string, optional): 服務狀態 = ['0: 停止營運', '1: 正常營運'],
//    AvailableRentBikes (integer, optional): 可租借車數 ,
//    AvailableReturnBikes (integer, optional): 可歸還車數 ,
//    SrcUpdateTime (DateTime): 來源端平台資料更新時間(ISO8601格式:yyyy-MM-ddTHH:mm:sszzz) ,
//    UpdateTime (DateTime): 資料更新日期時間(ISO8601格式:yyyy-MM-ddTHH:mm:sszzz)
//}

struct BikeStation: Codable {
    static let xizhiRailwayStation = "1002"
    
    let StationID: String
    let ServieAvailable: Int
    let AvailableRentBikes: Int
    let AvailableReturnBikes: Int
}
