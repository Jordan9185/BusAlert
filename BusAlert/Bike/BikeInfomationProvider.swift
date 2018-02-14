//
//  BikeAvailability.swift
//  BusAlert
//
//  Created by Chia cheng Lin on 2018/2/14.
//  Copyright © 2018年 Chia cheng Lin. All rights reserved.
//

import Foundation

protocol BikeInfomationProviderDelegate: class {
    func provider(prvider: BikeInfomationProvider, didGet bikeAvailabilityStation: BikeStation)
    func provider(prvider: BikeInfomationProvider, didFailWith error: BikeInfomationProviderError)
}

enum BikeInfomationProviderError: Error {
    case jsonConvertError
    case dataFetchError
    case urlFormatError
    case bikeNotFound
}

class BikeInfomationProvider {
    static let shard = BikeInfomationProvider()
    
    weak var delegate: BikeInfomationProviderDelegate?
    
    func getBikeAvailability(stationId: String) {
        let url = URL(string: "http://ptx.transportdata.tw/MOTC/v2/Bike/Availability/NewTaipei?$filter=StationID%20eq%20'\(stationId)'&$format=JSON")
        
        let urlRequest = MotcApp.urlRequestAddMotcHeader(url: url!)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, res, error) in
            
            if error != nil {
                self.delegate?.provider(prvider: self, didFailWith: .dataFetchError)
                return
            }
            
            let decoder = JSONDecoder()
            
            if let data = data,
                let bikeStations = try? decoder.decode([BikeStation].self, from: data)
            {
                if let bikeStation = bikeStations.first {
                    self.delegate?.provider(prvider: self, didGet: bikeStation)
                    print("車站代號", bikeStation.StationID)
                    print("可借車輛", bikeStation.AvailableRentBikes)
                    print("可還車輛", bikeStation.AvailableReturnBikes)
                } else {
                    self.delegate?.provider(prvider: self, didFailWith: .bikeNotFound)
                }
            } else {
                self.delegate?.provider(prvider: self, didFailWith: .jsonConvertError)
            }

        }.resume()
    }

}

