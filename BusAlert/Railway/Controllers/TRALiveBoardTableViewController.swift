//
//  TRALiveBoardTableViewController.swift
//  BusAlert
//
//  Created by Chia cheng Lin on 2018/2/9.
//  Copyright © 2018年 Chia cheng Lin. All rights reserved.
//

import UIKit

class TRALiveBoardTableViewController: UITableViewController {

    var timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
    
    var railLiveBoards: [RailLiveBoard] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return railLiveBoards.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveBoardTableViewCell", for: indexPath) as! LiveBoardTableViewCell
        let liveBoard = railLiveBoards[indexPath.row]
        cell.infomation.text = "車次:\(liveBoard.trainNo) 終站:\(liveBoard.endingStationNameZh) \n抵達時間:\(liveBoard.scheduledArrivalTime) 誤點:\(liveBoard.delayTime) 分鍾"
        return cell
    }
}

extension TRALiveBoardTableViewController: RailwayInfomationProviderDelegate {
    func provider(prvider: RailwayInfomationProvider, didGet railLiveBoards: [RailLiveBoard]) {
        //print(railLiveBoards)
        railLiveBoards.forEach { (liveBoard) in
            print("車次:\(liveBoard.trainNo) 方向:\(liveBoard.direction) 終站:\(liveBoard.endingStationNameZh) 抵達時間:\(liveBoard.scheduledArrivalTime) 誤點:\(liveBoard.delayTime)")
        }
        self.railLiveBoards = railLiveBoards
    }
    
    func provider(prvider: RailwayInfomationProvider, didFailWith error: RailwayInfomationProviderError) {
        print(error.localizedDescription)
    }
    
    
}
