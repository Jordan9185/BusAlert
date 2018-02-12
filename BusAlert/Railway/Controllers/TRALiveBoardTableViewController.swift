//
//  TRALiveBoardTableViewController.swift
//  BusAlert
//
//  Created by Chia cheng Lin on 2018/2/9.
//  Copyright © 2018年 Chia cheng Lin. All rights reserved.
//

import UIKit

enum Section {
    case northBound
    case southBound
}

class TRALiveBoardTableViewController: UITableViewController {
    // MARK: - Properties
    let sections: [Section] = [.northBound, .southBound]
    
    var timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
    
    var northBoundTrain: [RailLiveBoard] = []
    var southBoundTrain: [RailLiveBoard] = []
    
    var railLiveBoards: [RailLiveBoard] = [] {
        didSet {
            DispatchQueue.main.async {
                self.northBoundTrain = self.railLiveBoards.filter({ (liveBoard) -> Bool in
                    return liveBoard.direction == 0
                })
                self.southBoundTrain = self.railLiveBoards.filter({ (liveBoard) -> Bool in
                    return liveBoard.direction == 1
                })
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - App life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        RailwayInfomationProvider.share.delegate = self
        
        self.timer.schedule(deadline: DispatchTime.now(), repeating: .seconds(60), leeway: .milliseconds(10))
        
        self.timer.setEventHandler(handler: {
            DispatchQueue.main.sync {
                RailwayInfomationProvider.share.getTRALiveBoardInfomation(stationId: RailLiveBoard.HsichihStation)
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
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .northBound:
            return northBoundTrain.count
        case .southBound:
            return southBoundTrain.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveBoardTableViewCell", for: indexPath) as! LiveBoardTableViewCell
        
        switch sections[indexPath.section] {
        case .northBound:
            let liveBoard = northBoundTrain[indexPath.row]
            
            var msg = "往 \(liveBoard.endingStationNameZh) 的 \(liveBoard.trainClassificationId) 在 \(liveBoard.scheduledArrivalTime) 的時候會來喔！"
            
            if liveBoard.delayTime != 0 {
                msg += "，可能會晚個 \(liveBoard.delayTime) 分鐘吧..."
            }
            
            cell.infomation.text = msg
            
        case .southBound:
            let liveBoard = southBoundTrain[indexPath.row]
            
            var msg = "往 \(liveBoard.endingStationNameZh) 的 \(liveBoard.trainClassificationId) 在 \(liveBoard.scheduledArrivalTime) 的時候會來喔！"
            
            if liveBoard.delayTime != 0 {
                msg += "，可能會晚個 \(liveBoard.delayTime) 分鐘吧..."
            }
            
            cell.infomation.text = msg
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sections[section] {
        case .northBound:
            return "往基隆那邊"
        case .southBound:
            return "往台北那邊"
        }
    }
}

extension TRALiveBoardTableViewController: RailwayInfomationProviderDelegate {
    func provider(prvider: RailwayInfomationProvider, didGet railLiveBoards: [RailLiveBoard]) {
        railLiveBoards.forEach { (liveBoard) in
            print("車次:\(liveBoard.trainNo) 方向:\(liveBoard.direction) 終站:\(liveBoard.endingStationNameZh) 抵達時間:\(liveBoard.scheduledArrivalTime) 誤點:\(liveBoard.delayTime)")
        }
        self.railLiveBoards = railLiveBoards
    }
    
    func provider(prvider: RailwayInfomationProvider, didFailWith error: RailwayInfomationProviderError) {
        print(error.localizedDescription)
    }
}
