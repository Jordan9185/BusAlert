//
//  ViewController.swift
//  BusAlert
//
//  Created by Chia cheng Lin on 2018/2/6.
//  Copyright © 2018年 Chia cheng Lin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bl15Label: UILabel!
    @IBOutlet weak var f951Label: UILabel!
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
            return "預估再過 \(second) 秒 後抵達"
        }
        return "預估再過 \(second/60) 分 \(second%60) 秒 後抵達"
    }
    
    func provider(prvider: BusEstimateTimeProvider, didGet busEstimateTimes: [BusEstimateTime]) {
        
        let busEstimateTime = busEstimateTimes.first!

        if (busEstimateTime.estimateTime != "-1") {
            
            let estimateTime = secondToMinute(second: Int(busEstimateTime.estimateTime)!)
            
            DispatchQueue.main.async {
                if busEstimateTime.stopId == self.qiaodongBusStopFor951 {
                    self.f951Label.text = "951 \(estimateTime)"
                    print("951 \(estimateTime)")
                } else if busEstimateTime.stopId == self.qiaodongBusStopForBL15  {
                    self.bl15Label.text = "藍15 \(estimateTime)"
                    print("藍15 \(estimateTime)")
                }
            }
        }
    }
    
    func provider(prvider: BusEstimateTimeProvider, didFailWith error: BusEstimateTimeProviderError) {
        print(error.localizedDescription)
    }
}
