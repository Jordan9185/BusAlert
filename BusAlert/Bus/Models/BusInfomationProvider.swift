//
//  BusEstimateTimeProvider.swift
//  BusAlert
//
//  Created by Chia cheng Lin on 2018/2/6.
//  Copyright © 2018年 Chia cheng Lin. All rights reserved.
//

import Foundation

protocol BusInfomationProviderDelegate: class {
    func provider(prvider: BusInfomationProvider, didGet busGpsLocations: [BusGpsLocation])
    func provider(prvider: BusInfomationProvider, didFailWith error: BusInfomationProviderError)
}

enum BusInfomationProviderError: Error {
    case jsonConvertError
    case dataFetchError
    case routeNameError
    case urlFormatError
    case noCarComing(String)
}

class BusInfomationProvider {
    
    static let share: BusInfomationProvider = BusInfomationProvider()
    
    weak var delegate: BusInfomationProviderDelegate?
    
    func getBusLocation(routeName: String, goBack: Int, stopSequence: Int) throws {
        
        guard let encodeUrlString = routeName.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed) else {
                throw BusInfomationProviderError.routeNameError
        }

        if  let url = URL(string:"http://ptx.transportdata.tw/MOTC/v2/Bus/EstimatedTimeOfArrival/City/NewTaipei/\(encodeUrlString)?$filter=StopSequence%20le%20\(stopSequence)&$top=30&$format=JSON") {
            
            let urlRequest = MotcApp.urlRequestAddMotcHeader(url: url)
            
            URLSession.shared.dataTask(with: urlRequest) { (data, res, error) in
                if error != nil {
                    self.delegate?.provider(prvider: self, didFailWith: .dataFetchError)
                    return
                }
                
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: [])
                    
                    if let jsonDics = jsonData as? [[String: Any]] {
                        if jsonDics.count == 0 {
                            self.delegate?.provider(prvider: self, didFailWith: .noCarComing(routeName))
                            return
                        }
                        
                        var busGpsLocations: [BusGpsLocation] = []
                        
                        jsonDics.forEach({ (jsonDic) in
                            let busGpsLocation = BusGpsLocation(jsonDic: jsonDic)
                            if busGpsLocation.direction == goBack {
                                if (stopSequence - busGpsLocation.stopSequence) < 3 {
                                    busGpsLocations.append(busGpsLocation)
                                }
                            }
                        })
                        if busGpsLocations.count == 0 {
                            self.delegate?.provider(prvider: self, didFailWith: .noCarComing(routeName))
                        } else {
                            self.delegate?.provider(prvider: self, didGet: busGpsLocations)
                        }
                        
                    } else {
                        self.delegate?.provider(prvider: self, didFailWith: .jsonConvertError)
                    }
                    
                } catch {
                    self.delegate?.provider(prvider: self, didFailWith: .jsonConvertError)
                }
            }.resume()
        } else {
            throw BusInfomationProviderError.urlFormatError
        }
    }
}
