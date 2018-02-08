//
//  BackHomeViewController.swift
//  BusAlert
//
//  Created by Chia cheng Lin on 2018/2/8.
//  Copyright © 2018年 Chia cheng Lin. All rights reserved.
//

import UIKit

class BackHomeViewController: UIViewController {

    @IBOutlet weak var bl15Label: UILabel!
    @IBOutlet weak var f951Label: UILabel!
    @IBOutlet weak var lastUpdateTimeLabel: UILabel!
    let busInformationProvider: BusInfomationProvider = BusInfomationProvider()
    
    var timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timer.schedule(deadline: DispatchTime.now(), repeating: .seconds(30), leeway: .milliseconds(10))
        
        self.timer.setEventHandler(handler: {
            DispatchQueue.main.sync {
                self.getBusTime()
            }
        })
        
        self.timer.resume()
        
    }
    
    @objc func getBusTime() {
        busInformationProvider.delegate = self
        busInformationProvider.getBusBusEstimateTime(stopId: BusStop.nangangMRTFor951)
        busInformationProvider.getBusBusEstimateTime(stopId: BusStop.nangangMRTForBL15)
    }
    
    func labelAnimation(label: UILabel) {
        label.center.x = view.center.x
        label.center.x -= view.bounds.width
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
            label.center.x += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension BackHomeViewController: BusInfomationProviderDelegate {
    func provider(prvider: BusInfomationProvider, didGet busStops: [BusStop]) {
        
    }
    
    func secondToMinute(second: Int)-> String {
        if second == 0 {
            return "走了，搭下一班吧"
        }
        if second/60 == 0 {
            return "再過 \(second) 秒 後就來了，快點上車不要玩手機了"
        }
        return "再過 \(second/60) 分 \(second%60) 秒 後就來了，快點上車不要玩手機了"
    }
    
    func provider(prvider: BusInfomationProvider, didGet busEstimateTimes: [BusEstimateTime]) {
        
        let busEstimateTime = busEstimateTimes.first!
        
        DispatchQueue.main.async {
            switch busEstimateTime.estimateTime {
            case -1:
                if busEstimateTime.stopId == BusStop.nangangMRTFor951 {
                    self.f951Label.text = "951 還沒發車"
                } else if busEstimateTime.stopId == BusStop.nangangMRTForBL15  {
                    self.bl15Label.text = "藍15 還沒發車"
                }
            case -2:
                if busEstimateTime.stopId == BusStop.nangangMRTFor951 {
                    self.f951Label.text = "951 交管不停靠"
                } else if busEstimateTime.stopId == BusStop.nangangMRTForBL15  {
                    self.bl15Label.text = "藍15 交管不停靠"
                }
            case -3:
                if busEstimateTime.stopId == BusStop.nangangMRTFor951 {
                    self.f951Label.text = "951 沒車了ＱＱ 快打給成成"
                } else if busEstimateTime.stopId == BusStop.nangangMRTForBL15  {
                    self.bl15Label.text = "藍15 沒車了ＱＱ 快打給成成"
                }
            case -4:
                if busEstimateTime.stopId == BusStop.nangangMRTFor951 {
                    self.f951Label.text = "951 今天不開車顆顆"
                } else if busEstimateTime.stopId == BusStop.nangangMRTForBL15  {
                    self.bl15Label.text = "藍15 今天不開車顆顆"
                }
            default:
                let estimateTime = self.secondToMinute(second: busEstimateTime.estimateTime)
                
                if busEstimateTime.stopId == BusStop.nangangMRTFor951 {
                    self.f951Label.text = "951 \(estimateTime)"
                    print("951 \(estimateTime)")
                } else if busEstimateTime.stopId == BusStop.nangangMRTForBL15  {
                    self.bl15Label.text = "藍15 \(estimateTime)"
                    print("藍15 \(estimateTime)")
                }
            }
            
            if busEstimateTime.stopId == BusStop.nangangMRTFor951 {
                self.labelAnimation(label: self.f951Label)
            } else if busEstimateTime.stopId == BusStop.nangangMRTForBL15  {
                self.labelAnimation(label: self.bl15Label)
            }
            
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            
            let result = formatter.string(from: date)
            self.lastUpdateTimeLabel.text = "最後更新時間: \(result)"
        }
    }
    
    func provider(prvider: BusInfomationProvider, didFailWith error: BusInfomationProviderError) {
        print(error.localizedDescription)
    }
}
