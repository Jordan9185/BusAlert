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
        self.timer.schedule(deadline: DispatchTime.now(), repeating: .seconds(40), leeway: .milliseconds(10))
        
        self.timer.setEventHandler(handler: {
            DispatchQueue.main.sync {
                self.getBusTime()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.timer.resume()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer.suspend()
        
    }
    
    @IBAction func phoneCallForTaxi(_ sender: Any) {
        CommonFunction.phoneCall(who: "55688")
    }
    
    @IBAction func phoneCallForCheng(_ sender: Any) {
        CommonFunction.phoneCall(who: "0963051812")
    }
    
    @objc func getBusTime() {
        print("==========================")
        busInformationProvider.delegate = self
        do{
            try busInformationProvider.getBusLocation(routeName: "藍15", goBack: 1, stopSequence:10)
            try busInformationProvider.getBusLocation(routeName: "951", goBack: 1, stopSequence:31)
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
}

extension BackHomeViewController: BusInfomationProviderDelegate {
    func provider(prvider: BusInfomationProvider, didGet busGpsLocations: [BusGpsLocation]) {
        let closedBus = busGpsLocations.max { (bus1, bus2) -> Bool in
            return bus2.estimateTime > bus1.estimateTime
        }
        
        if let estimateTime = closedBus?.estimateTime,
            let routeName = closedBus?.routeNameZh,
            let stopName = closedBus?.stopNameZh {
            
            let formatEstimateTime = secondToMinute(second: estimateTime)

            let msg = "\(routeName) 再過 \(formatEstimateTime) 後就要到 \(stopName) 了，準備上車囉！！"
            print(msg)
            DispatchQueue.main.async {
                
                switch routeName {
                case "藍15":
                    self.bl15Label.text = msg
                    Animation.labelAnimation(label: self.bl15Label, view: self.view)
                    break
                case "951":
                    self.f951Label.text = msg
                    Animation.labelAnimation(label: self.f951Label, view: self.view)
                    break
                default:
                    print("unknown route")
                }
                
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                
                let result = formatter.string(from: date)
                self.lastUpdateTimeLabel.text = "最後更新時間: \(result)"
            }
        }
    }
    
    func secondToMinute(second: Int)-> String {
        if second/60 == 0 {
            return "\(second) 秒"
        }
        return "\(second/60) 分 \(second%60) 秒"
    }
    
    func provider(prvider: BusInfomationProvider, didFailWith error: BusInfomationProviderError) {
        
        switch error {
        case .noCarComing(let routeName):
            let msg = "\(routeName) 沒有車靠近(3站內)"
            print(msg)
            DispatchQueue.main.async {
                switch routeName {
                case "藍15":
                    self.bl15Label.text = msg
                    Animation.labelAnimation(label: self.bl15Label, view: self.view)
                    break
                case "951":
                    self.f951Label.text = msg
                    Animation.labelAnimation(label: self.f951Label, view: self.view)
                    break
                default:
                    print("unknown route")
                }
                
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                
                let result = formatter.string(from: date)
                self.lastUpdateTimeLabel.text = "最後更新時間: \(result)"
            }
        default:
            print(error.localizedDescription)
        }
    }
}

