//
//  TRALiveBoardTableViewController.swift
//  BusAlert
//
//  Created by Chia cheng Lin on 2018/2/9.
//  Copyright © 2018年 Chia cheng Lin. All rights reserved.
//

import UIKit

class TRALiveBoardTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveBoardTableViewCell", for: indexPath) as! LiveBoardTableViewCell

        return cell
    }
}
