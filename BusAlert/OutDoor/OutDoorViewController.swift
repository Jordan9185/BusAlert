//
//  ViewController.swift
//  BusAlert
//
//  Created by Chia cheng Lin on 2018/2/6.
//  Copyright © 2018年 Chia cheng Lin. All rights reserved.
//

import UIKit

class OutDoorViewController: UIViewController {

    @IBOutlet weak var bl15Label: UILabel!
    @IBOutlet weak var f951Label: UILabel!
    @IBOutlet weak var lastUpdateTimeLabel: UILabel!
    
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
        
        //BusInfomationProvider.share.getBusLocation(routeName: "藍15")
        //RailwayInfomationProvider.share.getTRALiveBoardInfomation(stationId: RailLiveBoard.HsichihStation)
    }
    
    @objc func getBusTime() {
        BusInfomationProvider.share.delegate = self
        BusInfomationProvider.share.getBusBusEstimateTime(stopId: BusStop.qiaodongFor951)
        BusInfomationProvider.share.getBusBusEstimateTime(stopId: BusStop.qiaodongForBL15)
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

extension OutDoorViewController: BusInfomationProviderDelegate {
    func provider(prvider: BusInfomationProvider, didGet busStops: [BusStop]) {
        
    }
    
    func secondToMinute(second: Int)-> String {
        if second == 0 {
            return "走了，搭下一班吧"
        }
        if second/60 == 0 {
            return "再過 \(second) 秒 後就來了，快出門"
        }
        return "再過 \(second/60) 分 \(second%60) 秒 後就來了，快出門"
    }
    
    func provider(prvider: BusInfomationProvider, didGet busEstimateTimes: [BusEstimateTime]) {
        
        let busEstimateTime = busEstimateTimes.first!

        DispatchQueue.main.async {
            switch busEstimateTime.estimateTime {
            case -1:
                if busEstimateTime.stopId == BusStop.qiaodongFor951 {
                    self.f951Label.text = "951 還沒發車"
                } else if busEstimateTime.stopId == BusStop.qiaodongForBL15  {
                    self.bl15Label.text = "藍15 還沒發車"
                }
            case -2:
                if busEstimateTime.stopId == BusStop.qiaodongFor951 {
                    self.f951Label.text = "951 交管不停靠"
                } else if busEstimateTime.stopId == BusStop.qiaodongForBL15  {
                    self.bl15Label.text = "藍15 交管不停靠"
                }
            case -3:
                if busEstimateTime.stopId == BusStop.qiaodongFor951 {
                    self.f951Label.text = "951 沒車了ＱＱ，就乖乖在家吧"
                } else if busEstimateTime.stopId == BusStop.qiaodongForBL15  {
                    self.bl15Label.text = "藍15 沒車了ＱＱ，就乖乖在家吧"
                }
            case -4:
                if busEstimateTime.stopId == BusStop.qiaodongFor951 {
                    self.f951Label.text = "951 今天不開車顆顆"
                } else if busEstimateTime.stopId == BusStop.qiaodongForBL15  {
                    self.bl15Label.text = "藍15 今天不開車顆顆"
                }
            default:
                let estimateTime = self.secondToMinute(second: busEstimateTime.estimateTime)
                
                if busEstimateTime.stopId == BusStop.qiaodongFor951 {
                    self.f951Label.text = "951 \(estimateTime)"
                    print("951 \(estimateTime)")
                } else if busEstimateTime.stopId == BusStop.qiaodongForBL15  {
                    self.bl15Label.text = "藍15 \(estimateTime)"
                    print("藍15 \(estimateTime)")
                }
            }
            
            if busEstimateTime.stopId == BusStop.qiaodongFor951 {
                self.labelAnimation(label: self.f951Label)
            } else if busEstimateTime.stopId == BusStop.qiaodongForBL15  {
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
