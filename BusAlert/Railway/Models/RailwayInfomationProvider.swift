//
//  RailwayInfomationProvider.swift
//  BusAlert
//
//  Created by Chia cheng Lin on 2018/2/7.
//  Copyright © 2018年 Chia cheng Lin. All rights reserved.
//

import Foundation
import CryptoSwift

protocol RailwayInfomationProviderDelegate: class {
    func provider(prvider: RailwayInfomationProvider, didGet railLiveBoards: [RailLiveBoard])
    func provider(prvider: RailwayInfomationProvider, didFailWith error: RailwayInfomationProviderError)
}

enum RailwayInfomationProviderError: Error {
    case jsonConvertError
    case dataFetchError
    case urlFormatError
}

class RailwayInfomationProvider {
    static let share = RailwayInfomationProvider()
    
    weak var delegate: RailwayInfomationProviderDelegate?
    
    func getTRALiveBoardInfomation(stationId: String) {
        
        let url = URL(string: "http://ptx.transportdata.tw/MOTC/v2/Rail/TRA/LiveBoard/Station/\(stationId)?$top=30&$format=JSON")
        
        let urlRequest = MotcApp.urlRequestAddMotcHeader(url: url!)

        URLSession.shared.dataTask(with: urlRequest) { (data, res, error) in

            if error != nil {
                self.delegate?.provider(prvider: self, didFailWith: .dataFetchError)
                return
            }
  
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                
                if let jsonDics = json as? [[String: Any]]{

                    if jsonDics.count == 0 {
                        //self.delegate?.provider(prvider: self, didFailWith: .noCarComing(routeName))
                        return
                    }
                    
                    var railLiveBoards: [RailLiveBoard] = []
                    
                    jsonDics.forEach({ (jsonDic) in
                        let railLiveBoard = RailLiveBoard(jsonDic: jsonDic)

                        railLiveBoards.append(railLiveBoard)
                    })
                    
                    self.delegate?.provider(prvider: self, didGet: railLiveBoards)
                }
            } catch {
                self.delegate?.provider(prvider: self, didFailWith: .jsonConvertError)
            }
        }.resume()
    }
}


