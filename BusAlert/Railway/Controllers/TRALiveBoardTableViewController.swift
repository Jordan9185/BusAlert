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

    var trainTypes: [TrainType] = [] {
        didSet {
            assignTrainName()
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
            
            var msg = "車次 \(liveBoard.trainNo) 往 \(liveBoard.endingStationNameZh) 的 \(liveBoard.trainTypeName) 在 \(liveBoard.scheduledArrivalTime) 的時候會來"
            
            if liveBoard.delayTime != 0 {
                msg += "\n也可能會晚個 \(liveBoard.delayTime) 分鐘吧..."
            }
            
            cell.infomation.text = msg
            
        case .southBound:
            let liveBoard = southBoundTrain[indexPath.row]
            
            var msg = "車次 \(liveBoard.trainNo) 往 \(liveBoard.endingStationNameZh) 的 \(liveBoard.trainTypeName) 在 \(liveBoard.scheduledArrivalTime) 的時候會來"
            
            if liveBoard.delayTime != 0 {
                msg += "\n也可能會晚個 \(liveBoard.delayTime) 分鐘吧..."
            }
            
            cell.infomation.text = msg
        }
        
        Animation.labelAnimation(label: cell.infomation, view: cell.contentView)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 128))
        let label = UILabel()
        let imageView = UIImageView()
        
        label.font = UIFont(name: "ChalkboardSE-Bold", size: 25)
        switch sections[section] {
        case .northBound:
            label.text = "往基隆那邊"
            imageView.image = #imageLiteral(resourceName: "train")
        case .southBound:
            label.text = "往台北那邊"
            imageView.image = #imageLiteral(resourceName: "train-revert")
        }

        imageView.contentMode = .scaleAspectFit
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        stackView.distribution = .fill
        stackView.axis = .horizontal
        imageView.widthAnchor.constraint(equalToConstant: 128).isActive = true
        
        return stackView
    }
    
    func assignTrainName() {
        DispatchQueue.main.async {
            let newRailLiveBorads = self.railLiveBoards.map({ (liveBoard) -> RailLiveBoard in
                
                var newLiveBoard = liveBoard
                let pickedTrainTypes = self.trainTypes.filter({ (trainType) -> Bool in
                    return liveBoard.trainClassificationId == trainType.TrainTypeID
                })
                
                guard let pickedTrainTypeName = pickedTrainTypes.first?.TrainTypeName.Zh_tw.split(separator: "(").first else {
                    
                    var pickedTrainTypeName = (pickedTrainTypes.first?.TrainTypeName.Zh_tw)!
                    
                    if pickedTrainTypes.first?.TrainTypeName.Zh_tw == "" {
                        pickedTrainTypeName = (pickedTrainTypes.first?.TrainTypeName.En)!
                    }
                    
                    newLiveBoard.trainTypeName = pickedTrainTypeName
                    
                    return newLiveBoard
                }
                
                newLiveBoard.trainTypeName = String(pickedTrainTypeName)
                
                return newLiveBoard
            })
            
            self.railLiveBoards = newRailLiveBorads
            self.tableView.reloadData()
        }
    }
}

extension TRALiveBoardTableViewController: RailwayInfomationProviderDelegate {
    func provider(prvider: RailwayInfomationProvider, didGet railLiveBoards: [RailLiveBoard]) {
        
//        railLiveBoards.forEach { (board) in
//            print(board.trainClassificationId)
//        }

        self.railLiveBoards = railLiveBoards
        
        if trainTypes.isEmpty {
            RailwayInfomationProvider.share.getTrainType()
        } else {
            self.assignTrainName()
        }
    }
    
    func provider(prvider: RailwayInfomationProvider, didFailWith error: RailwayInfomationProviderError) {
        print(error.localizedDescription)
    }
    
    func provider(prvider: RailwayInfomationProvider, didGet trainTypes: [TrainType]) {
        self.trainTypes = trainTypes
        //print(trainTypes)
    }
}
