//
//  SubViewController.swift
//  BottomSheetUI
//
//  Created by 麻生 拓弥 on 2018/11/30.
//  Copyright © 2018年 com.ASTK. All rights reserved.
//

import UIKit
import SafariServices

final class SubViewController: UIViewController {

    @IBOutlet weak var bottomSheetGuideImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let adImagesArray = ["AdBannar_01", "AdBannar_02", "AdBannar_03",
                                     "AdBannar_04", "AdBannar_05", "AdBannar_06",
                                     "AdBannar_07", "AdBannar_08", "AdBannar_09"]

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

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let cellNib = UINib(nibName: "AdBannerCollectionViewCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: "bannerCell")
        
    }

}

extension SubViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = "https://www.google.com"
        let safariVC = SFSafariViewController(url: URL(string: url)!)
        self.present(safariVC, animated: true, completion: nil)
    }
    
}

extension SubViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.adImagesArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as! AdBannerCollectionViewCell
        cell.bannerImageView.image = UIImage(named: self.adImagesArray[indexPath.row])
        return cell
    }
    
}

extension SubViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width - 16.0
        let height = width / 20 * 9
        return CGSize(width: width, height: height)
    }
    
}
