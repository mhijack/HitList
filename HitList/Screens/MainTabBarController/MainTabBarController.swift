//
//  MainTabBarController.swift
//  HitList
//
//  Created by Jianyuan Chen on 2021-02-28.
//  Copyright © 2021 Razeware. All rights reserved.
//

import UIKit
import SnapKit

class MainTabBarController: UITabBarController {
  
  private var initialCenter: CGPoint = CGPoint()
  private lazy var extraView: UIView = UIView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    setupExtraView()
  }
  
}

extension MainTabBarController {
  
  private func setupUI() {
    
  }
  
  private func setupExtraView() {
    extraView.isUserInteractionEnabled = true
    let pangesture = UIPanGestureRecognizer(target: self, action: #selector(extraViewDidPan))
    extraView.addGestureRecognizer(pangesture)
    
    view.addSubview(extraView)
    extraView.backgroundColor = .green
    extraView.snp.makeConstraints { (make) -> Void in
      make.height.equalTo(40)
      make.leading.equalTo(self.view.snp.leading).inset(20)
      make.trailing.equalTo(self.view.snp.trailing).inset(20)
      make.bottom.equalTo(self.tabBar.snp.top)
    }
  }
  
}

extension MainTabBarController {
  
  /// Extra view pan gesture recognizer
  /// - Parameter gestureRecognizer: UIPanGestureRecognizer
  @objc private func extraViewDidPan(_ gestureRecognizer : UIPanGestureRecognizer) {
    guard gestureRecognizer.view != nil else {return}
    let piece = gestureRecognizer.view!
    // Get the changes in the X and Y directions relative to
    // the superview's coordinate space.
    let translation = gestureRecognizer.translation(in: piece.superview)
    if gestureRecognizer.state == .began {
      // Save the view's original position.
      self.initialCenter = piece.center
    }
    // Update the position for the .began, .changed, and .ended states
    if gestureRecognizer.state != .cancelled {
      // Add the X and Y translation to the view's original position.
      let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
      piece.center = newCenter
    }
    else {
      // On cancellation, return the piece to its original location.
      piece.center = initialCenter
    }
  }
  
}
