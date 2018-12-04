//
//  MainViewController.swift
//  BottomSheetUI
//
//  Created by 麻生 拓弥 on 2018/11/30.
//  Copyright © 2018年 com.ASTK. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {

    @IBOutlet weak var containeeView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SubViewController {
            vc.bottomSheetDelegate = self
            vc.parentView = self.containeeView
        }
    }
}

extension MainViewController: BottomSheetDelegate {
    func updateBottomSheet(frame: CGRect) {
        self.containeeView.frame = frame
    }
}
