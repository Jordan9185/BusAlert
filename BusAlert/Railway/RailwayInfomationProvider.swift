//
//  RailwayInfomationProvider.swift
//  BusAlert
//
//  Created by Chia cheng Lin on 2018/2/7.
//  Copyright © 2018年 Chia cheng Lin. All rights reserved.
//

import Foundation
import CryptoSwift

class RailwayInfomationProvider {
    static let share = RailwayInfomationProvider()
    
    func getTRALiveBoardInfomation(stationId: String) {
        
        let url = URL(string: "http://ptx.transportdata.tw/MOTC/v2/Rail/TRA/LiveBoard/Station/\(stationId)?$top=30&$format=JSON")
        
        let urlRequest = MotcApp.urlRequestAddMotcHeader(url: url!)

        URLSession.shared.dataTask(with: urlRequest) { (data, res, error) in

            if error != nil {
                //self.delegate?.provider(prvider: self, didFailWith: .dataFetchError)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print(json)
                //if let jsonDictionary = json as? [[String: Any]]{

                    
                    //self.delegate?.provider(prvider: self, didGet: busEstimateTimes)
                
            } catch {
                //self.delegate?.provider(prvider: self, didFailWith: .jsonConvertError)
            }
        }.resume()
    }
}


