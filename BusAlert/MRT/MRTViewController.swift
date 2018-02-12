//
//  MRTViewController.swift
//  BusAlert
//
//  Created by Chia cheng Lin on 2018/2/12.
//  Copyright © 2018年 Chia cheng Lin. All rights reserved.
//

import UIKit

class MRTViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var mrtMapImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mrtMapImageView
    }
}
