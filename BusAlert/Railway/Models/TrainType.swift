//
//  TrainType.swift
//  BusAlert
//
//  Created by Chia cheng Lin on 2018/2/12.
//  Copyright © 2018年 Chia cheng Lin. All rights reserved.
//

import Foundation

//{
//    "TrainTypeID": "1115",
//    "TrainTypeName": {
//        "Zh_tw": "莒光(有身障座位 ,有自行車車廂)",
//        "En": "Chu-Kuang Express"
//    },
//    "TrainTypeCode": "2",
//    "UpdateTime": "2016-07-06T12:40:00+08:00"
//}

struct TrainType: Codable {
    struct Name: Codable {
        let Zh_tw: String
        let En: String
    }
    let TrainTypeID: String
    let TrainTypeName: Name
    let TrainTypeCode: String
    let UpdateTime: String
}
