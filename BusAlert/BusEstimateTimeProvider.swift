//
//  BusEstimateTimeProvider.swift
//  BusAlert
//
//  Created by Chia cheng Lin on 2018/2/6.
//  Copyright © 2018年 Chia cheng Lin. All rights reserved.
//

import Foundation

protocol BusEstimateTimeProviderDelegate: class {
    func provider(prvider: BusEstimateTimeProvider, didGet busEstimateTimes: [BusEstimateTime])
    func provider(prvider: BusEstimateTimeProvider, didFailWith error: BusEstimateTimeProviderError)
}

enum BusEstimateTimeProviderError: Error {
    case jsonConvertError
    case dataFetchError
}

class BusEstimateTimeProvider {
    
    enum status {
        //    0：去程
        //    1：返程
        //    2：尚未發車
        //    3：末班已駛離去返程
        case toKunyang
        case toHsichih
        case notYetStarted
        case outOfTime
    }
    
    static let share: BusEstimateTimeProvider = BusEstimateTimeProvider()
    
    weak var delegate: BusEstimateTimeProviderDelegate?
    
    func getBusBusEstimateTime(stopId: String) {
        
        let url = URL(string: "http://data.ntpc.gov.tw/od/data/api/245793DB-0958-4C10-8D63-E7FA0D39207C?$format=json&$filter=StopID%20eq%20\(stopId)")
        
        URLSession.shared.dataTask(with: url!) { (data, res, error) in
            var busEstimateTimes: [BusEstimateTime] = []
            if error != nil {
                self.delegate?.provider(prvider: self, didFailWith: .dataFetchError)
                return
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data!, options: [])
                
                if let records = jsonData as? [[String: String]]{
                    records.forEach({ (record) in
                        let newBusEstimateTime = BusEstimateTime(
                            estimateTime: record["EstimateTime"]!,
                            goBack: record["GoBack"]!,
                            routeId: record["RouteID"]!,
                            stopId: record["StopID"]!
                        )
                        
                        busEstimateTimes.append(newBusEstimateTime)
                    })

                    self.delegate?.provider(prvider: self, didGet: busEstimateTimes)
                }
            } catch {
                self.delegate?.provider(prvider: self, didFailWith: .jsonConvertError)
            }
        }.resume()
    }
}
