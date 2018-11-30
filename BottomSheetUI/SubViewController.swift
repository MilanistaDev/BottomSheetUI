//
//  SubViewController.swift
//  BottomSheetUI
//
//  Created by 麻生 拓弥 on 2018/11/30.
//  Copyright © 2018年 com.ASTK. All rights reserved.
//

import UIKit
import SafariServices

enum SheetPosition {
    case top, bottom
}

protocol BottomSheetDelegate {
    func updateBottomSheet(frame: CGRect)
}

final class SubViewController: UIViewController {

    @IBOutlet weak var bottomSheetGuideImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var bottomSheetDelegate: BottomSheetDelegate?
    var parentView: UIView!

    let initalFrame: CGRect = UIScreen.main.bounds
    let topY: CGFloat = (UIApplication.shared.statusBarFrame.size.height > 20) ? 120.0 : 86.0
    var middleY: CGFloat!
    var bottomY: CGFloat!
    var bottomOffset: CGFloat = (UIApplication.shared.statusBarFrame.size.height > 20) ? 98.0 : 64.0
    var lastPosition: SheetPosition = .bottom
    var lastY: CGFloat!
    var disableTableScroll = false

    fileprivate let adImagesArray = ["AdBannar_01", "AdBannar_02", "AdBannar_03",
                                     "AdBannar_04", "AdBannar_05", "AdBannar_06",
                                     "AdBannar_07", "AdBannar_08", "AdBannar_09"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstSettings()
        self.setUpUI()
    }

    fileprivate func firstSettings() {
        // Bottom と中間の y 座標を決める
        self.bottomY = self.initalFrame.height - self.bottomOffset
        self.middleY = (self.topY + self.bottomY) / 2
        self.lastY = self.bottomY
        self.bottomSheetDelegate?.updateBottomSheet(frame: self.initalFrame.offsetBy(dx: 0, dy: self.lastY))
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

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(swipePan(_:)))
        self.view.addGestureRecognizer(panGesture)
        self.collectionView.panGestureRecognizer.addTarget(self, action: #selector(swipePan(_:)))
    }

    @objc
    func swipePan(_ recognizer: UIPanGestureRecognizer) {
        if (self.collectionView.contentOffset.y > 0) { return }

        let dy = recognizer.translation(in: self.parentView).y
        switch recognizer.state {
        case .changed:
            self.bottomSheetGuideImageView.image = UIImage(named: "img_arrow_flat_guide")
            if (self.collectionView.contentOffset.y <= 0) {
                let maxY = max(topY, lastY + dy)
                let y = min(bottomY, maxY)
                bottomSheetDelegate?.updateBottomSheet(frame: self.initalFrame.offsetBy(dx: 0, dy: y))
            }
            if (self.parentView.frame.minY > topY) {
                self.collectionView.contentOffset.y = 0
            }
        case .failed, .ended, .cancelled:
            self.view.isUserInteractionEnabled = false
            self.disableTableScroll = self.lastPosition != .top
            self.lastY = self.parentView.frame.minY
            self.lastPosition = self.nextPosition(recognizer: recognizer)

            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9, options: .curveEaseOut, animations: {
                var bottomSheetFrame: CGRect
                switch self.lastPosition {
                case .top:
                    bottomSheetFrame = self.initalFrame.offsetBy(dx: 0, dy: self.topY)
                    self.collectionView.contentInset.bottom = self.topY + 50
                case .bottom:
                    bottomSheetFrame = self.initalFrame.offsetBy(dx: 0, dy: self.bottomY)
                }
                self.bottomSheetDelegate?.updateBottomSheet(frame: bottomSheetFrame)
            }) { (_) in
                self.view.isUserInteractionEnabled = true
                self.lastY = self.parentView.frame.minY
                switch self.lastPosition {
                case .top:
                    self.bottomSheetGuideImageView.image = UIImage(named: "img_arrow_down_guide")
                case .bottom:
                    self.bottomSheetGuideImageView.image = UIImage(named: "img_arrow_up_guide")
                }
            }
        default:
            break
        }
    }

    func nextPosition(recognizer: UIPanGestureRecognizer) -> SheetPosition {

        let velY = recognizer.velocity(in: self.view).y
        if (velY < -200) {
            return (self.lastY > self.middleY) ? .bottom: .top
        } else if (velY > 200) {
            return (self.lastY < self.middleY + 1) ? .top: .bottom
        } else {
            if (self.lastY > self.middleY) {
                return ((self.lastY - self.middleY) < (self.bottomY - self.lastY)) ? .top: .bottom
            } else {
                return ((self.lastY - self.topY) < (self.middleY - self.lastY)) ? .top: .bottom
            }
        }
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

extension SubViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == collectionView else { return }
        if (self.parentView.frame.minY > topY) {
            self.collectionView.contentOffset.y = 0
        }
    }

    // TableViewが意図せずトップに行かないように制御
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == collectionView else { return }
        if disableTableScroll {
            targetContentOffset.pointee = scrollView.contentOffset
            disableTableScroll = false
        }
    }
}
