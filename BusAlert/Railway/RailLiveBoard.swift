//
//  RailLiveBoard.swift
//  BusAlert
//
//  Created by Chia cheng Lin on 2018/2/7.
//  Copyright © 2018年 Chia cheng Lin. All rights reserved.
//

import Foundation
//RailLiveBoard {
//    StationID (string): 車站代碼 ,
//    StationName (NameType): 車站名稱 ,
//    TrainNo (string): 車次代碼 ,
//    Direction (string): 順逆行 = ['0: 順行', '1: 逆行'],
//    TrainClassificationID (string): 列車車種代碼 ,
//    TripLine (string, optional): 山海線類型 = ['0: 不經山海線', '1: 山線', '2: 海線'],
//    EndingStationID (string): 車次終點車站代號 ,
//    EndingStationName (NameType): 車次終點車站名稱 ,
//    ScheduledArrivalTime (string): 表訂到站時間(格式: HH:mm:ss) ,
//    ScheduledDepartureTime (string): 表訂離站時間(格式: HH:mm:ss) ,
//    DelayTime (integer): 誤點時間(0:準點;>=1誤點) ,
//    SrcUpdateTime (DateTime): 來源端平台資料更新時間(ISO8601格式:yyyy-MM-ddTHH:mm:sszzz) ,
//    UpdateTime (DateTime): 本平台資料更新時間(ISO8601格式:yyyy-MM-ddTHH:mm:sszzz)
//}

struct RailLiveBoard {
    static let HsichihStation: String = "1005"
    let stationId: String
    let stationName: String
    let trainNo: String
    let direction: String
    let trainClassificationId: String
    let tripLine: String
    let endingStationId: String
    let endingStationName: String
    let scheduledArrivalTime: String
    let scheduledDepartureTime: String
    let DelayTime: Int
    let SrcUpdateTime: String
    let UpdateTime: String
}
