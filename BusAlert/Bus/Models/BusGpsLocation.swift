//
//  BusGpsLocation.swift
//  BusAlert
//
//  Created by Chia cheng Lin on 2018/2/9.
//  Copyright © 2018年 Chia cheng Lin. All rights reserved.
//

import Foundation

//ex.
//{
//    Direction = 1;
//    EstimateTime = 119;
//    MessageType = 0;
//    RouteID = 16296;
//    RouteName =         {
//        En = BL15;
//        "Zh_tw" = "\U85cd15";
//    };
//    RouteUID = NWT16296;
//    SrcUpdateTime = "2018-02-09T09:47:50+08:00";
//    StopID = 115007;
//    StopName =         {
//        En = "Nangang High School";
//        "Zh_tw" = "\U5357\U6e2f\U9ad8\U4e2d";
//    };
//    StopSequence = 2;
//    StopUID = NWT115007;
//    UpdateTime = "2018-02-09T09:47:55+08:00";
//}

struct BusGpsLocation {
    let direction: Int
    let estimateTime: Int
    let messageType: Int
    let routeId: String
    let routeNameEn: String
    let routeNameZh: String
    let routeUid: String
    let srcUpdateTime: String
    let stopId: String
    let stopNameEn: String
    let stopNameZh: String
    let stopSequence: Int
    let stopUid: String
    let updateTime: String
    
    init () {
        self.direction = 0
        self.estimateTime = 0
        self.messageType = 0
        self.routeId = ""
        self.routeNameEn = ""
        self.routeNameZh = ""
        self.routeUid = ""
        self.srcUpdateTime = ""
        self.stopId = ""
        self.stopNameEn = ""
        self.stopNameZh = ""
        self.stopSequence = 0
        self.stopUid = ""
        self.updateTime = ""
    }
    
    init(jsonDic: [String:Any]) {

        if let direction = jsonDic["Direction"] as? Int {
            self.direction = direction
        } else {
            self.direction = 0
        }
        
        if let estimateTime = jsonDic["EstimateTime"] as? Int{
            self.estimateTime = estimateTime
        } else {
            self.estimateTime = 0
        }
        
        if let messageType = jsonDic["MessageType"] as? Int {
            self.messageType = messageType
        } else {
            self.messageType = 0
        }
        
        if let routeId = jsonDic["RouteID"] as? String {
            self.routeId = routeId
        } else {
            self.routeId = ""
        }
        
        if let routeName = jsonDic["RouteName"] as? [String:String] {
            self.routeNameEn = routeName["En"] ?? ""
            self.routeNameZh = routeName["Zh_tw"] ?? ""
        } else {
            self.routeNameEn = ""
            self.routeNameZh = ""
        }
        
        if let routeUid = jsonDic["RouteUID"] as? String {
            self.routeUid = routeUid
        } else {
            self.routeUid = ""
        }
        
        if let srcUpdateTime = jsonDic["SrcUpdateTime"] as? String {
            self.srcUpdateTime = srcUpdateTime
        } else {
            self.srcUpdateTime = ""
        }
        
        if let stopId = jsonDic["StopID"] as? String {
            self.stopId = stopId
        } else {
            self.stopId = ""
        }
        
        if let stopName = jsonDic["StopName"] as? [String:String] {
            self.stopNameEn = stopName["En"] ?? ""
            self.stopNameZh = stopName["Zh_tw"] ?? ""
        } else {
            self.stopNameEn = ""
            self.stopNameZh = ""
        }
        
        if let stopSequence = jsonDic["StopSequence"] as? Int {
            self.stopSequence = stopSequence
        } else {
            self.stopSequence = 0
        }
        
        if let stopUid = jsonDic["StopUID"] as? String {
            self.stopUid = stopUid
        } else {
            self.stopUid = ""
        }
        
        if let updateTime = jsonDic["updateTime"] as? String{
            self.updateTime = updateTime
        } else {
            self.updateTime = ""
        }
    }
}
