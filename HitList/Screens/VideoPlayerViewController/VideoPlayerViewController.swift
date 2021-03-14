//
//  VideoPlayerViewController.swift
//  HitList
//
//  Created by Jianyuan Chen on 2021-02-28.
//  Copyright © 2021 Razeware. All rights reserved.
//

import UIKit
import SnapKit
import AVKit

class VideoPlayerViewController: UIViewController {
  
  private lazy var playerView: UIView = UIView()
  private weak var player: AVPlayer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViewController()
    setupUI()
    setupVideo()
  }
  
}

extension VideoPlayerViewController {
  
  private func setupViewController() {
    
  }
  
  private func setupUI() {
    view.addSubview(playerView)
    playerView.backgroundColor = .red
    playerView.snp.makeConstraints { (make) -> Void in
      make.width.height.equalTo(300)
      make.center.equalTo(self.view)
    }
  }
  
  private func setupVideo() {
    guard let videourl = Bundle.main.url(forResource: "test-mp4", withExtension: "mp4") else {
      navigationController?.popViewController(animated: true)
      return
    }
    
    let player = AVPlayer(url: videourl)
    self.player = player
    let layer: AVPlayerLayer = AVPlayerLayer(player: player)
    layer.backgroundColor = UIColor.white.cgColor
    layer.frame = playerView.bounds
    layer.videoGravity = .resizeAspectFill
    playerView.layer.sublayers?
      .filter { $0 is AVPlayerLayer }
      .forEach { $0.removeFromSuperlayer() }
    playerView.layer.addSublayer(layer)
    player.play()
  }
  
}
