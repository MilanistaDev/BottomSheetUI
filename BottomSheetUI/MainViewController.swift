//
//  MainViewController.swift
//  BottomSheetUI
//
//  Created by 麻生 拓弥 on 2018/11/30.
//  Copyright © 2018年 com.ASTK. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bottomSheetFirstHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bottomSheetFirstHeight.constant = (UIApplication.shared.statusBarFrame.size.height > 20) ? 98.0 : 64.0
    }
}
