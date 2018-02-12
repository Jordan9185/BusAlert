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
    let stationNameZh: String
    let stationNameEn: String
    let trainNo: String
    let direction: Int
    let trainClassificationId: String
    let tripLine: Int
    let endingStationId: String
    let endingStationNameZh: String
    let endingStationNameEn: String
    let scheduledArrivalTime: String
    let scheduledDepartureTime: String
    let delayTime: Int
    let srcUpdateTime: String
    let updateTime: String
    
    init() {
        self.stationId = ""
        self.stationNameZh = ""
        self.stationNameEn = ""
        self.trainNo = ""
        self.direction = 0
        self.trainClassificationId = ""
        self.tripLine = 0
        self.endingStationId = ""
        self.endingStationNameZh = ""
        self.endingStationNameEn = ""
        self.scheduledArrivalTime = ""
        self.scheduledDepartureTime = ""
        self.delayTime = 0
        self.srcUpdateTime = ""
        self.updateTime = ""
    }
    
    init(jsonDic: [String:Any]) {
        if let delayTime = jsonDic["DelayTime"] as? Int {
            self.delayTime = delayTime
        } else {
            self.delayTime = 0
        }
        
        if let direction = jsonDic["Direction"] as? Int {
            self.direction = direction
        } else {
            self.direction = 0
        }
        
        if let endingStationId = jsonDic["EndingStationID"] as? String {
            self.endingStationId = endingStationId
        } else {
            self.endingStationId = ""
        }
        
        if let endingStationName = jsonDic["EndingStationName"] as? [String:String] {
            self.endingStationNameZh = endingStationName["Zh_tw"] ?? ""
            self.endingStationNameEn = endingStationName["En"] ?? ""
        } else {
            self.endingStationNameZh = ""
            self.endingStationNameEn = ""
        }
        
        if let scheduledArrivalTime = jsonDic["ScheduledArrivalTime"] as? String {
            self.scheduledArrivalTime = scheduledArrivalTime
        } else {
            self.scheduledArrivalTime = ""
        }
        
        if let scheduledDepartureTime = jsonDic["ScheduledDepartureTime"] as? String {
            self.scheduledDepartureTime = scheduledDepartureTime
        } else {
            self.scheduledDepartureTime = ""
        }
        
        if let srcUpdateTime = jsonDic["SrcUpdateTime"] as? String {
            self.srcUpdateTime = srcUpdateTime
        } else {
            self.srcUpdateTime = ""
        }
        
        if let stationId = jsonDic["StationID"] as? String {
            self.stationId = stationId
        } else {
            self.stationId = ""
        }
        
        if let stationName = jsonDic["StationName"] as? [String:String] {
            self.stationNameZh = stationName["Zh_tw"] ?? ""
            self.stationNameEn = stationName["En"] ?? ""
        } else {
            self.stationNameZh = ""
            self.stationNameEn = ""
        }
        
        if let trainClassificationId = jsonDic["TrainClassificationID"] as? String {
            self.trainClassificationId = trainClassificationId
        } else {
            self.trainClassificationId = ""
        }
        
        if let trainNo = jsonDic["TrainNo"] as? String {
            self.trainNo = trainNo
        } else {
            self.trainNo = ""
        }
        
        if let tripLine = jsonDic["TripLine"] as? Int {
            self.tripLine = tripLine
        } else {
            self.tripLine = 0
        }
        
        if let updateTime = jsonDic["UpdateTime"] as? String {
            self.updateTime = updateTime
        } else {
            self.updateTime = ""
        }
    }
}
