//
//  ViewController.swift
//  BusAlert
//
//  Created by Chia cheng Lin on 2018/2/6.
//  Copyright © 2018年 Chia cheng Lin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let qiaodongBusStopForBL15: String = "114984"
    let qiaodongBusStopFor951: String = "180691"
    var timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.timer.schedule(deadline: DispatchTime.now(), repeating: .seconds(60), leeway: .milliseconds(10))

        self.timer.setEventHandler(handler: {
            DispatchQueue.main.sync {
                self.getBusTime()
            }
        })
        
        self.timer.resume()
    }

    @objc func getBusTime() {
        BusEstimateTimeProvider.share.delegate = self
        BusEstimateTimeProvider.share.getBusBusEstimateTime(stopId: qiaodongBusStopForBL15)
        BusEstimateTimeProvider.share.getBusBusEstimateTime(stopId: qiaodongBusStopFor951)
    }
}

extension ViewController: BusEstimateTimeProviderDelegate {
    
    func secondToMinute(second: Int)-> String {
        if second == 0 {
            return "已離站"
        }
        if second/60 == 0 {
            return "再過 \(second) 秒 後抵達"
        }
        return "再過 \(second/60) 分 \(second%60) 秒 後抵達"
    }
    
    func provider(prvider: BusEstimateTimeProvider, didGet busEstimateTimes: [BusEstimateTime]) {
        
        let busEstimateTime = busEstimateTimes.first!

        if (busEstimateTime.estimateTime != "-1") {
            
            let estimateTime = secondToMinute(second: Int(busEstimateTime.estimateTime)!)
            
            if busEstimateTime.stopId == qiaodongBusStopFor951 {
                print("951 \(estimateTime)")
            } else if busEstimateTime.stopId == qiaodongBusStopForBL15  {
                print("BL15 \(estimateTime)")
            }
        }
    }
    
    func provider(prvider: BusEstimateTimeProvider, didFailWith error: BusEstimateTimeProviderError) {
        print(error.localizedDescription)
    }
}
