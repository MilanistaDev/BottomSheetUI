//
//  SubViewController.swift
//  BottomSheetUI
//
//  Created by 麻生 拓弥 on 2018/11/30.
//  Copyright © 2018年 com.ASTK. All rights reserved.
//

import UIKit

final class SubViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }

    fileprivate func setUpUI() {
        self.view.layer.cornerRadius = 20.0
        self.view.layer.masksToBounds = false
        self.view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.view.layer.shadowOpacity = 0.3
        self.view.layer.shadowColor = UIColor.black.cgColor
        self.view.layer.shadowRadius = 10.0
    }
}
