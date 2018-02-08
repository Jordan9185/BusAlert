//
//  BusEstimateTimeProvider.swift
//  BusAlert
//
//  Created by Chia cheng Lin on 2018/2/6.
//  Copyright © 2018年 Chia cheng Lin. All rights reserved.
//

import Foundation

protocol BusInfomationProviderDelegate: class {
    func provider(prvider: BusInfomationProvider, didGet busStops: [BusStop])
    func provider(prvider: BusInfomationProvider, didGet busEstimateTimes: [BusEstimateTime])
    func provider(prvider: BusInfomationProvider, didFailWith error: BusInfomationProviderError)
}

enum BusInfomationProviderError: Error {
    case jsonConvertError
    case dataFetchError
}

class BusInfomationProvider {
    
    static let share: BusInfomationProvider = BusInfomationProvider()
    
    weak var delegate: BusInfomationProviderDelegate?
    
    func getBusLocation(routeName: String) {
//        let url = URL(string: "http://data.ntpc.gov.tw/od/data/api/62519D6B-9B6D-43E1-BFD7-D66007005E6F?$format=json&$filter=routeId%20eq%20\(routeId)")
       
        let url =  URL(string:"http://ptx.transportdata.tw/MOTC/v2/Bus/EstimatedTimeOfArrival/City/NewTaipei/%E8%97%8D15?$filter=StopSequence%20le%204&$top=30&$format=JSON")

        let urlRequest = MotcApp.urlRequestAddMotcHeader(url: url!)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, res, error) in
            if error != nil {
                self.delegate?.provider(prvider: self, didFailWith: .dataFetchError)
                return
            }

            do {
                let jsonData = try JSONSerialization.jsonObject(with: data!, options: [])
                if let jsonDic = jsonData as? [String:Any] {
                    print(jsonDic)
                }
                
            } catch {
                self.delegate?.provider(prvider: self, didFailWith: .jsonConvertError)
            }
        }.resume()
    }
    
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
                        
                        var goBack:GoBack = .unknown
                        
                        switch (record["GoBack"]!) {
                        case "0":
                            goBack = .go
                            break
                        case "1":
                            goBack = .back
                            break
                        default:
                            goBack = .unknown
                            break
                        }
                        
                        let newBusEstimateTime = BusEstimateTime(
                            estimateTime: Int(record["EstimateTime"]!)!,
                            goBack: goBack,
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
