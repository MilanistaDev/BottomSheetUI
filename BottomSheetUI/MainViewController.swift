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
    @IBOutlet var safeAreaBottomToContaineeTopConstraint: NSLayoutConstraint!
    @IBOutlet var containeeTopToSafeAreaTopConstraint: NSLayoutConstraint!
    
    private var subViewController: SubViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContaineeView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SubViewController {
            subViewController = vc
        }
    }
}

extension MainViewController {
    
    private func setupContaineeView() {
        
        if let subview = subViewController?.view {
            containeeView.addSubview(subview)
        }
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(sender:)))
        containeeView.addGestureRecognizer(panGestureRecognizer)
        
    }
    
}

extension MainViewController {
    
    private func layoutContainee() {
        
        view.setNeedsLayout()
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: { [view] in
            view?.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    private func showContainee() {
        
        safeAreaBottomToContaineeTopConstraint.isActive = false
        containeeTopToSafeAreaTopConstraint.isActive = true
        layoutContainee()
        
    }
    
    private func hideContainee() {
        
        safeAreaBottomToContaineeTopConstraint.isActive = true
        containeeTopToSafeAreaTopConstraint.isActive = false
        layoutContainee()
        
    }
    
}

extension MainViewController {
    
    private func dragContaineeVertically(by dy: CGFloat) {
        
        containeeView.center.y += dy
        containeeView.frame.size.height -= dy
        
    }
    
    private func setContaineePositionAccordingToCurrentContaineeYLocation() {
        
        let boundsMidY = view.frame.midY
        
        switch containeeView.frame.minY {
        case ...boundsMidY:
            showContainee()
            
        case boundsMidY...:
            hideContainee()
            
        case _:
            assertionFailure("Impossible case")
        }
        
    }
    
    private func setContaineePosition(accordingToGestureYVelocity gestureYVelocity: CGFloat) {
        
        let showContaineeVelocityMaxThreashold: CGFloat = -5
        let hideContaineeVelocityMinThreashold: CGFloat = 5
        
        switch gestureYVelocity {
        case ...showContaineeVelocityMaxThreashold:
            showContainee()
            
        case hideContaineeVelocityMinThreashold...:
            hideContainee()
            
        default:
            setContaineePositionAccordingToCurrentContaineeYLocation()
        }
        
    }
    
    private func resetContaineePosition() {
        
        layoutContainee()
        
    }
    
    private func moveContaineeView(accordingTo gestureRecognizer: UIPanGestureRecognizer) {
        
        assert(gestureRecognizer.view === containeeView)
        
        defer {
            gestureRecognizer.setTranslation(.zero, in: nil)
        }
        
        switch gestureRecognizer.state {
        case .began, .changed:
            dragContaineeVertically(by: gestureRecognizer.translation(in: nil).y)
            
        case .ended:
            setContaineePosition(accordingToGestureYVelocity: gestureRecognizer.velocity(in: nil).y)
            
        case .cancelled, .failed:
            resetContaineePosition()
            
        case .possible:
            break
        }
        
    }
    
}

extension MainViewController {
    
    @objc private func onPan(sender: UIPanGestureRecognizer) {
        
        switch sender.view {
        case containeeView:
            moveContaineeView(accordingTo: sender)
            
        case let invalid:
            assertionFailure("Invalid swipe gesture sent from \(invalid as Any)")
        }
        
    }
    
}

extension MainViewController: BottomSheetDelegate {
    func updateBottomSheet(frame: CGRect) {
        self.containeeView.frame = frame
    }
}
